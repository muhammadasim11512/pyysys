# 🚀 Full-Stack Application - DevOps Complete Solution

[![CI/CD Pipeline](https://github.com/yourusername/fullstack-redis-app/actions/workflows/ci-cd.yaml/badge.svg)](https://github.com/yourusername/fullstack-redis-app/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Complete DevOps solution featuring Kubernetes (EKS), Terraform Infrastructure as Code, automated CI/CD pipeline, and security best practices.

## 📋 Project Overview

This project demonstrates a production-ready full-stack application deployment on AWS using modern DevOps practices:

- **Infrastructure as Code**: Terraform for AWS EKS, VPC, ECR, S3
- **Container Orchestration**: Kubernetes with auto-scaling and health checks
- **CI/CD Pipeline**: GitHub Actions with automated testing, security scanning, and deployment
- **Security**: Non-root containers, secrets management, vulnerability scanning
- **Monitoring**: Health checks, resource limits, logging

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│  ┌────────────────────────────────────────────────────┐    │
│  │              Amazon EKS Cluster                     │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │    │
│  │  │ Frontend │  │ Backend  │  │  Redis   │        │    │
│  │  │  React   │  │ Node.js  │  │  Cache   │        │    │
│  │  └──────────┘  └──────────┘  └──────────┘        │    │
│  │  ┌──────────┐  ┌─────────────────────────┐       │    │
│  │  │ MongoDB  │  │  NGINX Ingress          │       │    │
│  │  └──────────┘  └─────────────────────────┘       │    │
│  └────────────────────────────────────────────────────┘    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │   ECR    │  │    S3    │  │   VPC    │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Features

### Application Stack
- **Frontend**: React + TypeScript + Vite + Tailwind CSS
- **Backend**: Node.js + Express + MongoDB + Redis
- **Database**: MongoDB 7.0 with authentication
- **Cache**: Redis 7 Alpine for performance

### DevOps Features
- ✅ **Terraform IaC**: Complete AWS infrastructure automation
- ✅ **Kubernetes**: EKS cluster with 2 worker nodes
- ✅ **CI/CD Pipeline**: Automated build, test, scan, and deploy
- ✅ **Security Scanning**: Trivy vulnerability scanning
- ✅ **Code Quality**: SonarQube integration
- ✅ **Container Registry**: AWS ECR with image scanning
- ✅ **Artifact Storage**: S3 bucket for build artifacts
- ✅ **Ingress Controller**: NGINX for routing
- ✅ **Health Checks**: Liveness and readiness probes
- ✅ **Resource Management**: CPU/Memory limits and requests
- ✅ **Security Context**: Non-root users, dropped capabilities
- ✅ **Secrets Management**: Kubernetes secrets for sensitive data

## 📦 Repository Structure

```
fullstack-redis-app/
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # EKS, VPC, ECR, S3 resources
│   ├── variables.tf          # Terraform variables
│   └── outputs.tf            # Output values
├── k8s/                      # Kubernetes manifests
│   ├── namespace.yaml        # Application namespace
│   ├── configmap.yaml        # Configuration
│   ├── secret.yaml           # Sensitive data
│   ├── mongodb-deployment.yaml
│   ├── redis-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   └── ingress.yaml          # Routing rules
├── .github/workflows/        # CI/CD pipeline
│   └── ci-cd.yaml           # GitHub Actions workflow
├── server/                   # Backend application
│   ├── Dockerfile           # Backend container
│   ├── index.js             # Express server
│   ├── routes/              # API routes
│   └── models/              # Database models
├── my-app/                   # Frontend application
│   ├── Dockerfile           # Frontend container
│   ├── src/                 # React source code
│   └── public/              # Static assets
├── docs/                     # Documentation
│   ├── AWS-DEPLOYMENT.md    # Detailed deployment guide
│   └── QUICK-SETUP.md       # Quick start guide
├── deploy-aws.sh            # Automated deployment script
├── sonar-project.properties # SonarQube configuration
└── README.md                # This file
```

## 🚀 Quick Start

### Prerequisites
- AWS Account with admin access
- AWS CLI configured
- Terraform >= 1.0
- kubectl >= 1.28
- Docker >= 20.0

### One-Command Deployment
```bash
chmod +x deploy-aws.sh
./deploy-aws.sh
```

This will:
1. Create EKS cluster and VPC
2. Set up ECR repositories
3. Create S3 bucket
4. Install NGINX Ingress Controller
5. Deploy MongoDB and Redis

### Configure GitHub Secrets
Add to **Settings → Secrets → Actions**:
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
S3_BUCKET_NAME
SONAR_TOKEN (optional)
SONAR_HOST_URL (optional)
```

### Deploy Application
```bash
git add .
git commit -m "Deploy to AWS"
git push origin main
```

## 📚 Documentation

- **[Quick Setup Guide](docs/QUICK-SETUP.md)** - Step-by-step setup instructions
- **[AWS Deployment Guide](docs/AWS-DEPLOYMENT.md)** - Detailed deployment documentation
- **[Architecture Overview](docs/ARCHITECTURE.md)** - System architecture details

## 🔄 CI/CD Pipeline

### Pipeline Stages

1. **Build and Test**
   - Install dependencies
   - Run unit tests
   - Build frontend application

2. **Security Scanning**
   - Trivy vulnerability scan (filesystem)
   - Dependency audit
   - SARIF report upload

3. **Code Quality**
   - SonarQube analysis
   - Code coverage report
   - Quality gate check

4. **Build and Push**
   - Build Docker images
   - Scan images with Trivy
   - Push to AWS ECR
   - Upload artifacts to S3

5. **Deploy to EKS**
   - Update Kubernetes deployments
   - Rolling update strategy
   - Health check verification
   - Deployment validation

### Pipeline Triggers
- **Push to main/master**: Full pipeline with deployment
- **Pull Request**: Build and test only

## 🔐 Security Features

### Container Security
- Non-root users (UID 1001/999)
- Read-only root filesystem
- Dropped all Linux capabilities
- No privilege escalation
- Security context enforced

### Kubernetes Security
- Secrets for sensitive data
- ConfigMaps for configuration
- Resource limits and requests
- Network policies (optional)
- RBAC enabled

### Image Security
- Trivy vulnerability scanning
- ECR automatic image scanning
- Alpine-based minimal images
- Regular security updates

## 🌐 Application Access

### Get Application URL
```bash
kubectl get ingress app-ingress -n fullstack-app
```

### Endpoints
```
http://<INGRESS-URL>/          → Frontend UI
http://<INGRESS-URL>/api       → Backend API
http://<INGRESS-URL>/api/health → Health Check
```

## 📊 API Endpoints

### Health & Monitoring
- `GET /health` - Application health status
- `GET /api/` - API information

### User Management
- `GET /api/users` - List all users
- `POST /api/users` - Create user
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Task Management
- `GET /api/tasks` - List all tasks
- `POST /api/tasks` - Create task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task

## 🛠️ Management Commands

### Kubernetes Operations
```bash
# Check pod status
kubectl get pods -n fullstack-app

# View logs
kubectl logs -f <pod-name> -n fullstack-app

# Scale deployment
kubectl scale deployment backend --replicas=3 -n fullstack-app

# Restart deployment
kubectl rollout restart deployment/backend -n fullstack-app

# Check resource usage
kubectl top pods -n fullstack-app
```

### Terraform Operations
```bash
cd terraform

# Plan changes
terraform plan

# Apply changes
terraform apply

# View outputs
terraform output

# Destroy infrastructure
terraform destroy
```

## 📈 Monitoring and Logging

### View Application Logs
```bash
# Backend logs
kubectl logs -l app=backend -n fullstack-app --tail=100 -f

# Frontend logs
kubectl logs -l app=frontend -n fullstack-app --tail=100 -f

# Database logs
kubectl logs -l app=mongodb -n fullstack-app --tail=100 -f
```

### Check Resource Usage
```bash
kubectl top nodes
kubectl top pods -n fullstack-app
```

## 🧹 Cleanup

### Delete Application
```bash
kubectl delete namespace fullstack-app
```

### Destroy Infrastructure
```bash
cd terraform
terraform destroy
```

## 💰 Cost Estimation

**Approximate AWS costs:**
- EKS Cluster: $73/month
- EC2 (2x t3.medium): ~$60/month
- Load Balancer: ~$20/month
- **Total: ~$150-200/month**

## 🎯 DevOps Assignment Compliance

### ✅ Phase 1: Infrastructure (Terraform instead of VMs)
- EKS cluster with 2 worker nodes
- VPC with public/private subnets
- Automated setup with Terraform

### ✅ Phase 2: Application Containerization
- Frontend Dockerfile (Alpine, non-root, healthcheck)
- Backend Dockerfile (Alpine, non-root, healthcheck)
- Redis container
- MongoDB container
- .dockerignore files

### ✅ Phase 3: Kubernetes Deployment
- Namespace
- Deployments with replicas
- Services (ClusterIP)
- ConfigMap
- Secret
- Ingress
- Liveness/Readiness probes
- Resource limits

### ✅ Phase 4: Ingress Setup
- NGINX Ingress Controller
- Routing: / → frontend, /api → backend
- Browser accessible

### ✅ Phase 5: CI/CD Pipeline
- Build and test
- SonarQube quality scan
- Trivy security scan
- Docker build and push to ECR
- Automated deployment to EKS

### ✅ Phase 6: Security
- Non-root containers
- securityContext configured
- Resource limits
- Secrets management
- Vulnerability scanning

### ✅ Bonus Features
- Terraform IaC
- S3 artifact storage
- ECR container registry
- Comprehensive documentation
- Automated deployment script

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- AWS for cloud infrastructure
- Kubernetes community
- Terraform by HashiCorp
- GitHub Actions
- Open source community

---

**Built with ❤️ for DevOps Excellence**

**Ready for Production Deployment! 🚀**
