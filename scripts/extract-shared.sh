#!/bin/bash

# -----------------------------
# CONFIGURATION
# -----------------------------
REGION="ap-south-1"
OUTPUT_DIR="outputs/shared"

mkdir -p $OUTPUT_DIR

echo "📦 Extracting Shared Stack Resources..."

# -----------------------------
# LOAD BALANCERS (ALB/NLB)
# -----------------------------
echo "🔹 Load Balancers..."
aws elbv2 describe-load-balancers \
  --region $REGION \
  > $OUTPUT_DIR/load-balancers.json

# -----------------------------
# TARGET GROUPS
# -----------------------------
echo "🔹 Target Groups..."
aws elbv2 describe-target-groups \
  --region $REGION \
  > $OUTPUT_DIR/target-groups.json

# -----------------------------
# LISTENERS
# -----------------------------
echo "🔹 Listeners..."
aws elbv2 describe-listeners \
  --region $REGION \
  > $OUTPUT_DIR/listeners.json

# -----------------------------
# LISTENER RULES
# -----------------------------
echo "🔹 Listener Rules..."
for listener in $(jq -r '.Listeners[].ListenerArn' $OUTPUT_DIR/listeners.json); do
  aws elbv2 describe-rules \
    --listener-arn $listener \
    --region $REGION \
    >> $OUTPUT_DIR/listener-rules.json
done

# -----------------------------
# ECS CLUSTERS
# -----------------------------
echo "🔹 ECS Clusters..."
aws ecs list-clusters \
  --region $REGION \
  > $OUTPUT_DIR/ecs-clusters-list.json

CLUSTERS=$(jq -r '.clusterArns[]' $OUTPUT_DIR/ecs-clusters-list.json)

for cluster in $CLUSTERS; do
  aws ecs describe-clusters \
    --clusters $cluster \
    --region $REGION \
    >> $OUTPUT_DIR/ecs-clusters.json
done

# -----------------------------
# ECS CAPACITY PROVIDERS (OPTIONAL)
# -----------------------------
echo "🔹 ECS Capacity Providers..."
aws ecs describe-capacity-providers \
  --region $REGION \
  > $OUTPUT_DIR/ecs-capacity.json

# -----------------------------
# ROUTE53 HOSTED ZONES
# -----------------------------
echo "🔹 Route53 Hosted Zones..."
aws route53 list-hosted-zones \
  > $OUTPUT_DIR/route53-zones.json

# -----------------------------
# ROUTE53 RECORDS
# -----------------------------
echo "🔹 Route53 Records..."
for zone in $(jq -r '.HostedZones[].Id' $OUTPUT_DIR/route53-zones.json); do
  zoneId=$(echo $zone | sed 's/\/hostedzone\///')
  aws route53 list-resource-record-sets \
    --hosted-zone-id $zoneId \
    >> $OUTPUT_DIR/route53-records.json
done

# -----------------------------
# S3 BUCKETS (SHARED)
# -----------------------------
echo "🔹 S3 Buckets..."
aws s3api list-buckets \
  > $OUTPUT_DIR/s3-buckets.json

# -----------------------------
# IAM ROLES (IMPORTANT)
# -----------------------------
echo "🔹 IAM Roles..."
aws iam list-roles \
  > $OUTPUT_DIR/iam-roles.json

# -----------------------------
# IAM POLICIES (OPTIONAL)
# -----------------------------
echo "🔹 IAM Policies..."
aws iam list-policies \
  --scope Local \
  > $OUTPUT_DIR/iam-policies.json

# -----------------------------
# CLOUDWATCH LOG GROUPS
# -----------------------------
echo "🔹 CloudWatch Logs..."
aws logs describe-log-groups \
  --region $REGION \
  > $OUTPUT_DIR/log-groups.json

echo "✅ Shared stack extraction completed!"
echo "📁 Files stored in: $OUTPUT_DIR"
