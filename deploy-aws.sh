#!/bin/bash

set -e

echo "🚀 Starting Deployment Process..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Initialize Terraform
echo -e "${BLUE}📦 Step 1: Initializing Terraform...${NC}"
cd terraform
terraform init

# Step 2: Plan Infrastructure
echo -e "${BLUE}📋 Step 2: Planning Infrastructure...${NC}"
terraform plan -out=tfplan

# Step 3: Apply Infrastructure
echo -e "${BLUE}🏗️  Step 3: Creating AWS Infrastructure...${NC}"
terraform apply tfplan

# Get outputs
echo -e "${BLUE}📝 Getting Terraform Outputs...${NC}"
CLUSTER_NAME=$(terraform output -raw cluster_name)
S3_BUCKET=$(terraform output -raw s3_bucket_name)
ECR_FRONTEND=$(terraform output -raw ecr_frontend_url)
ECR_BACKEND=$(terraform output -raw ecr_backend_url)
AWS_ACCESS_KEY=$(terraform output -raw github_actions_access_key)
AWS_SECRET_KEY=$(terraform output -raw github_actions_secret_key)

echo -e "${GREEN}✅ Infrastructure Created!${NC}"
echo "Cluster Name: $CLUSTER_NAME"
echo "S3 Bucket: $S3_BUCKET"
echo "ECR Frontend: $ECR_FRONTEND"
echo "ECR Backend: $ECR_BACKEND"

# Step 4: Configure kubectl
echo -e "${BLUE}⚙️  Step 4: Configuring kubectl...${NC}"
aws eks update-kubeconfig --region us-east-1 --name $CLUSTER_NAME

# Step 5: Install NGINX Ingress Controller
echo -e "${BLUE}🌐 Step 5: Installing NGINX Ingress Controller...${NC}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml

# Wait for ingress controller
echo "Waiting for NGINX Ingress Controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Step 6: Deploy Application
echo -e "${BLUE}🚀 Step 6: Deploying Application to Kubernetes...${NC}"
cd ../k8s

kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f redis-deployment.yaml

# Wait for databases
echo "Waiting for databases..."
kubectl wait --for=condition=ready pod -l app=mongodb -n fullstack-app --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis -n fullstack-app --timeout=120s

# Note: Backend and Frontend will be deployed via CI/CD
echo -e "${BLUE}ℹ️  Backend and Frontend will be deployed via CI/CD pipeline${NC}"

kubectl apply -f ingress.yaml

echo -e "${GREEN}✅ Deployment Complete!${NC}"

# Step 7: Display Information
echo -e "${BLUE}📊 Deployment Information:${NC}"
echo ""
echo "Add these secrets to your GitHub repository:"
echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY"
echo "AWS_SECRET_ACCESS_KEY: $AWS_SECRET_KEY"
echo "S3_BUCKET_NAME: $S3_BUCKET"
echo ""
echo "Get Ingress URL:"
kubectl get ingress app-ingress -n fullstack-app

echo ""
echo -e "${GREEN}🎉 Setup Complete! Push code to trigger CI/CD pipeline.${NC}"
