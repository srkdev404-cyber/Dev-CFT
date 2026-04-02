#!/bin/bash

# -----------------------------
# CONFIGURATION
# -----------------------------
REGION="us-east-1"
OUTPUT_DIR="outputs/network"

mkdir -p $OUTPUT_DIR

echo "📦 Extracting AWS Network Resources..."

# -----------------------------
# VPC
# -----------------------------
echo "🔹 VPC..."
aws ec2 describe-vpcs \
  --region $REGION \
  > $OUTPUT_DIR/vpcs.json

# -----------------------------
# SUBNETS
# -----------------------------
echo "🔹 Subnets..."
aws ec2 describe-subnets \
  --region $REGION \
  > $OUTPUT_DIR/subnets.json

# -----------------------------
# ROUTE TABLES
# -----------------------------
echo "🔹 Route Tables..."
aws ec2 describe-route-tables \
  --region $REGION \
  > $OUTPUT_DIR/route-tables.json

# -----------------------------
# INTERNET GATEWAY
# -----------------------------
echo "🔹 Internet Gateways..."
aws ec2 describe-internet-gateways \
  --region $REGION \
  > $OUTPUT_DIR/igw.json

# -----------------------------
# NAT GATEWAYS
# -----------------------------
echo "🔹 NAT Gateways..."
aws ec2 describe-nat-gateways \
  --region $REGION \
  > $OUTPUT_DIR/nat.json

# -----------------------------
# SECURITY GROUPS
# -----------------------------
echo "🔹 Security Groups..."
aws ec2 describe-security-groups \
  --region $REGION \
  > $OUTPUT_DIR/security-groups.json

# -----------------------------
# NETWORK ACLs
# -----------------------------
echo "🔹 Network ACLs..."
aws ec2 describe-network-acls \
  --region $REGION \
  > $OUTPUT_DIR/nacls.json

# -----------------------------
# ELASTIC IPs
# -----------------------------
echo "🔹 Elastic IPs..."
aws ec2 describe-addresses \
  --region $REGION \
  > $OUTPUT_DIR/eips.json

# -----------------------------
# VPC ENDPOINTS
# -----------------------------
echo "🔹 VPC Endpoints..."
aws ec2 describe-vpc-endpoints \
  --region $REGION \
  > $OUTPUT_DIR/vpc-endpoints.json

# -----------------------------
# DHCP OPTIONS
# -----------------------------
echo "🔹 DHCP Options..."
aws ec2 describe-dhcp-options \
  --region $REGION \
  > $OUTPUT_DIR/dhcp.json

# -----------------------------
# TAGGING (VERY IMPORTANT)
# -----------------------------
echo "🔹 Tagged Resources..."
aws resourcegroupstaggingapi get-resources \
  --region $REGION \
  > $OUTPUT_DIR/tags.json

echo "✅ Network extraction completed!"
echo "📁 Files stored in: $OUTPUT_DIR"
