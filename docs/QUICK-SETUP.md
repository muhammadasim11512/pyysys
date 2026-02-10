# 🚀 Quick Setup Guide

## Prerequisites Checklist
- [ ] AWS Account with admin access
- [ ] AWS CLI installed and configured
- [ ] Terraform installed (>= 1.0)
- [ ] kubectl installed (>= 1.28)
- [ ] GitHub account
- [ ] Docker installed

## Step-by-Step Setup

### 1️⃣ Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### 2️⃣ Clone and Setup Repository
```bash
git clone <your-repo-url>
cd fullstack-redis-app
chmod +x deploy-aws.sh
```

### 3️⃣ Deploy Infrastructure
```bash
./deploy-aws.sh
```

**This will take 15-20 minutes and will:**
- Create EKS cluster with 2 worker nodes
- Set up VPC with public/private subnets
- Create ECR repositories for Docker images
- Create S3 bucket for artifacts
- Install NGINX Ingress Controller
- Deploy MongoDB and Redis

### 4️⃣ Save Terraform Outputs
```bash
cd terraform
terraform output > ../outputs.txt
```

**Important outputs:**
- `github_actions_access_key` - For GitHub secrets
- `github_actions_secret_key` - For GitHub secrets
- `s3_bucket_name` - For GitHub secrets
- `cluster_name` - EKS cluster name
- `ecr_frontend_url` - Frontend ECR URL
- `ecr_backend_url` - Backend ECR URL

### 5️⃣ Configure GitHub Secrets

Go to: **GitHub Repository → Settings → Secrets and variables → Actions**

Add these secrets:
```
AWS_ACCESS_KEY_ID: <from terraform output>
AWS_SECRET_ACCESS_KEY: <from terraform output>
S3_BUCKET_NAME: <from terraform output>
```

**Optional (for SonarQube):**
```
SONAR_TOKEN: <your-token>
SONAR_HOST_URL: https://sonarcloud.io
```

### 6️⃣ Push Code to Trigger CI/CD
```bash
git add .
git commit -m "Deploy to AWS EKS"
git push origin main
```

### 7️⃣ Monitor Deployment

**Watch GitHub Actions:**
- Go to: **GitHub Repository → Actions**
- Click on the running workflow
- Monitor each stage

**Watch Kubernetes:**
```bash
# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name fullstack-app-cluster

# Watch pods
kubectl get pods -n fullstack-app -w

# Check deployment status
kubectl rollout status deployment/backend -n fullstack-app
kubectl rollout status deployment/frontend -n fullstack-app
```

### 8️⃣ Get Application URL
```bash
kubectl get ingress app-ingress -n fullstack-app
```

**Output will show:**
```
NAME          CLASS   HOSTS   ADDRESS                                    PORTS   AGE
app-ingress   nginx   *       a1b2c3d4-123456789.us-east-1.elb.amazonaws.com   80      5m
```

**Access your application:**
```
http://<ADDRESS>/          → Frontend
http://<ADDRESS>/api       → Backend API
http://<ADDRESS>/api/health → Health Check
```

## ✅ Verification Steps

### Check All Pods Running
```bash
kubectl get pods -n fullstack-app
```

**Expected output:**
```
NAME                        READY   STATUS    RESTARTS   AGE
backend-xxx-yyy             1/1     Running   0          5m
backend-xxx-zzz             1/1     Running   0          5m
frontend-xxx-yyy            1/1     Running   0          5m
frontend-xxx-zzz            1/1     Running   0          5m
mongodb-xxx-yyy             1/1     Running   0          10m
redis-xxx-yyy               1/1     Running   0          10m
```

### Test Backend Health
```bash
INGRESS_URL=$(kubectl get ingress app-ingress -n fullstack-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl http://$INGRESS_URL/api/health
```

### Test Frontend
```bash
curl http://$INGRESS_URL/
```

## 🔧 Common Issues

### Issue: Pods in Pending State
**Solution:**
```bash
kubectl describe pod <pod-name> -n fullstack-app
# Check for resource constraints or node issues
```

### Issue: Ingress Not Getting External IP
**Solution:**
```bash
# Check ingress controller
kubectl get pods -n ingress-nginx
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
```

### Issue: CI/CD Pipeline Fails at Deploy Stage
**Solution:**
- Verify AWS credentials in GitHub secrets
- Check if kubectl can access cluster
- Ensure ECR repositories exist

### Issue: Database Connection Errors
**Solution:**
```bash
# Check MongoDB
kubectl logs -l app=mongodb -n fullstack-app

# Check Redis
kubectl logs -l app=redis -n fullstack-app

# Verify secrets
kubectl get secret app-secrets -n fullstack-app -o yaml
```

## 🧹 Cleanup (When Done)

### Delete Kubernetes Resources
```bash
kubectl delete namespace fullstack-app
```

### Destroy AWS Infrastructure
```bash
cd terraform
terraform destroy
```

**⚠️ Warning:** This will delete:
- EKS cluster
- VPC and networking
- ECR repositories and images
- S3 bucket and contents
- All associated resources

## 📊 Cost Estimation

**Approximate monthly costs:**
- EKS Cluster: $73/month
- EC2 Instances (2x t3.medium): ~$60/month
- Load Balancer: ~$20/month
- Data Transfer: Variable
- **Total: ~$150-200/month**

**To minimize costs:**
- Use spot instances for worker nodes
- Scale down when not in use
- Delete resources when testing is complete

## 🎯 Next Steps

1. ✅ Set up monitoring (CloudWatch, Prometheus)
2. ✅ Configure auto-scaling (HPA)
3. ✅ Add persistent volumes for databases
4. ✅ Set up backup strategy
5. ✅ Configure SSL/TLS certificates
6. ✅ Implement network policies
7. ✅ Set up logging (ELK stack)

## 📞 Support

If you encounter issues:
1. Check the logs: `kubectl logs <pod-name> -n fullstack-app`
2. Review GitHub Actions logs
3. Check AWS CloudWatch logs
4. Verify all prerequisites are met

---

**Happy Deploying! 🚀**
