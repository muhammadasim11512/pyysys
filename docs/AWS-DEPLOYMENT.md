# 🚀 Full-Stack Application - AWS EKS Deployment with CI/CD

Complete DevOps solution with Terraform, Kubernetes (EKS), and automated CI/CD pipeline.

## 📋 Table of Contents
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Infrastructure Setup](#infrastructure-setup)
- [CI/CD Pipeline](#cicd-pipeline)
- [Application Access](#application-access)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │              Amazon EKS Cluster                     │    │
│  │                                                     │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │    │
│  │  │ Frontend │  │ Backend  │  │  Redis   │        │    │
│  │  │  (2 pods)│  │ (2 pods) │  │ (1 pod)  │        │    │
│  │  └──────────┘  └──────────┘  └──────────┘        │    │
│  │                                                     │    │
│  │  ┌──────────┐                                      │    │
│  │  │ MongoDB  │                                      │    │
│  │  │ (1 pod)  │                                      │    │
│  │  └──────────┘                                      │    │
│  │                                                     │    │
│  │  ┌─────────────────────────────────────┐          │    │
│  │  │    NGINX Ingress Controller         │          │    │
│  │  │  / → Frontend  |  /api → Backend    │          │    │
│  │  └─────────────────────────────────────┘          │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │   ECR    │  │    S3    │  │   VPC    │                 │
│  │ Registry │  │  Bucket  │  │ Network  │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Components

### Infrastructure (Terraform)
- **EKS Cluster**: Managed Kubernetes with 2 worker nodes (t3.medium)
- **VPC**: Custom VPC with public/private subnets across 2 AZs
- **ECR**: Container registry for Docker images
- **S3**: Artifact storage bucket
- **IAM**: Roles and policies for GitHub Actions

### Application Stack
- **Frontend**: React + TypeScript + Vite (Nginx)
- **Backend**: Node.js + Express + MongoDB + Redis
- **Database**: MongoDB 7.0
- **Cache**: Redis 7 Alpine

### CI/CD Pipeline
- Build and test
- SonarQube code quality analysis
- Trivy security scanning
- Docker image build and push to ECR
- Automated deployment to EKS

## 🔧 Prerequisites

### Required Tools
```bash
# AWS CLI
aws --version  # >= 2.0

# Terraform
terraform --version  # >= 1.0

# kubectl
kubectl version --client  # >= 1.28

# Docker
docker --version  # >= 20.0
```

### AWS Account Setup
1. AWS account with admin access
2. AWS CLI configured with credentials
3. Sufficient quota for EKS and EC2 resources

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <your-repo-url>
cd fullstack-redis-app
```

### 2. Deploy Infrastructure
```bash
chmod +x deploy-aws.sh
./deploy-aws.sh
```

This script will:
- ✅ Create EKS cluster
- ✅ Set up VPC and networking
- ✅ Create ECR repositories
- ✅ Create S3 bucket
- ✅ Install NGINX Ingress Controller
- ✅ Deploy MongoDB and Redis

### 3. Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets → Actions):

```
AWS_ACCESS_KEY_ID: <from terraform output>
AWS_SECRET_ACCESS_KEY: <from terraform output>
S3_BUCKET_NAME: <from terraform output>
SONAR_TOKEN: <your sonarqube token>
SONAR_HOST_URL: <your sonarqube url>
```

### 4. Trigger CI/CD Pipeline

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

The pipeline will automatically:
1. Build and test the application
2. Run security scans
3. Build Docker images
4. Push to ECR
5. Deploy to EKS

## 📚 Detailed Setup

### Infrastructure Setup (Terraform)

```bash
cd terraform

# Initialize Terraform
terraform init

# Review plan
terraform plan

# Apply infrastructure
terraform apply

# Get outputs
terraform output
```

### Manual Kubernetes Deployment

```bash
# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name fullstack-app-cluster

# Deploy application
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/redis-deployment.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/ingress.yaml

# Check status
kubectl get all -n fullstack-app
```

## 🔄 CI/CD Pipeline

### Pipeline Stages

1. **Build and Test**
   - Install dependencies
   - Run unit tests
   - Build frontend

2. **Security Scanning**
   - Trivy vulnerability scan
   - Dependency audit

3. **Code Quality**
   - SonarQube analysis
   - Code coverage

4. **Build and Push**
   - Build Docker images
   - Scan images with Trivy
   - Push to ECR
   - Upload artifacts to S3

5. **Deploy**
   - Update Kubernetes deployments
   - Rolling update strategy
   - Health check verification

### Pipeline Triggers
- Push to `main` or `master` branch
- Pull requests (build and test only)

## 🌐 Application Access

### Get Ingress URL
```bash
kubectl get ingress app-ingress -n fullstack-app
```

### Access Application
```
http://<INGRESS-URL>/          → Frontend
http://<INGRESS-URL>/api       → Backend API
http://<INGRESS-URL>/api/health → Health Check
```

## 📊 Monitoring

### Check Pod Status
```bash
kubectl get pods -n fullstack-app
kubectl logs -f <pod-name> -n fullstack-app
```

### Check Services
```bash
kubectl get services -n fullstack-app
```

### Check Ingress
```bash
kubectl describe ingress app-ingress -n fullstack-app
```

### Resource Usage
```bash
kubectl top nodes
kubectl top pods -n fullstack-app
```

## 🔐 Security Features

### Container Security
- ✅ Non-root users (UID 1001/999)
- ✅ Read-only root filesystem where possible
- ✅ Dropped all capabilities
- ✅ No privilege escalation
- ✅ Security context configured

### Kubernetes Security
- ✅ Secrets for sensitive data
- ✅ ConfigMaps for configuration
- ✅ Resource limits and requests
- ✅ Liveness and readiness probes
- ✅ Network policies (optional)

### Image Security
- ✅ Trivy vulnerability scanning
- ✅ ECR image scanning enabled
- ✅ Alpine-based images (minimal attack surface)

## 🛠️ Troubleshooting

### Pods Not Starting
```bash
kubectl describe pod <pod-name> -n fullstack-app
kubectl logs <pod-name> -n fullstack-app
```

### Ingress Not Working
```bash
kubectl get ingress -n fullstack-app
kubectl describe ingress app-ingress -n fullstack-app
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
```

### Database Connection Issues
```bash
# Check MongoDB
kubectl exec -it <mongodb-pod> -n fullstack-app -- mongosh -u admin -p password123

# Check Redis
kubectl exec -it <redis-pod> -n fullstack-app -- redis-cli -a redis123 ping
```

### CI/CD Pipeline Failures
- Check GitHub Actions logs
- Verify AWS credentials
- Ensure ECR repositories exist
- Check kubectl access to cluster

## 🧹 Cleanup

### Destroy Infrastructure
```bash
cd terraform
terraform destroy
```

### Delete Kubernetes Resources
```bash
kubectl delete namespace fullstack-app
```

## 📈 Scaling

### Manual Scaling
```bash
kubectl scale deployment backend --replicas=3 -n fullstack-app
kubectl scale deployment frontend --replicas=3 -n fullstack-app
```

### Auto-scaling (HPA)
```bash
kubectl autoscale deployment backend --cpu-percent=70 --min=2 --max=5 -n fullstack-app
```

## 🎯 Performance Optimization

- Use ECR image caching
- Enable cluster autoscaler
- Configure pod disruption budgets
- Implement horizontal pod autoscaling
- Use persistent volumes for databases

## 📝 Additional Resources

- [Terraform AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [GitHub Actions](https://docs.github.com/en/actions)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 License

MIT License

---

**Built with ❤️ for DevOps Excellence**
