# CI/CD Pipeline — End-to-End DevOps Project

A complete DevOps project demonstrating automated CI/CD pipeline using Jenkins, Docker, Kubernetes, Helm, and AWS EKS — with full GitOps workflow from GitHub push to live deployment.

---

## Architecture Overview

<img width="592" height="465" alt="image" src="https://github.com/user-attachments/assets/cf5dc2f6-fba6-4246-8d19-9078cd6ae17c" />


---

## Tech Stack

| Tool | Purpose | Server |
|---|---|---|
| GitHub | Source Code Management | Cloud |
| Jenkins | CI/CD Automation | AWS EC2 - Jenkins Server |
| Docker | Containerization | AWS EC2 - Jenkins Server |
| AWS ECR | Container Image Registry | Cloud |
| AWS EKS | Kubernetes Cluster | Cloud |
| Helm | Kubernetes Package Manager | Jenkins Server |
| Nginx Ingress | Traffic Routing | EKS Cluster |
| AWS EC2 | Cloud Infrastructure | AWS |

---

## CI/CD Pipeline Flow

```
Step 1: Developer pushes code to GitHub
            ↓
Step 2: GitHub Webhook triggers Jenkins automatically
            ↓
Step 3: Jenkins pulls latest code from GitHub
            ↓
Step 4: Node.js dependencies installed & health check test runs
        • PASSED → Continue pipeline
        • FAILED → Pipeline stops
            ↓
Step 5: Jenkins builds Docker image
        docker build -t cicd-demo-app:${BUILD_NUMBER}
            ↓
Step 6: Image pushed to AWS ECR
        docker push <account>.dkr.ecr.us-east-2.amazonaws.com/cicd-demo-app
            ↓
Step 7: Jenkins connects to AWS EKS cluster
            ↓
Step 8: Helm deploys latest image to Kubernetes
            ↓
Step 9: Nginx Ingress routes traffic via AWS Load Balancer
        App is LIVE!
```

---

## Infrastructure Setup

**Jenkins Server**
- OS: Ubuntu 24.04 LTS
- Cloud: AWS EC2 — m7i-flex.large
- Installed: Jenkins, Java 17, Docker, AWS CLI, kubectl, eksctl, Helm
- Port: 8080

**EKS Cluster**
- Cluster Name: cicd-cluster
- Region: us-east-2
- Worker Nodes: 2 × m7i-flex.large
- Namespace: production

---

## Project Structure

```
cicd-demo-app/
│
├── server.js              # Node.js Express app
├── test.js                # Health check test
├── package.json           # Dependencies
├── Dockerfile             # Docker configuration
├── Jenkinsfile            # CI/CD pipeline script
└── helm/
    └── cicd-demo-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            └── ingress.yaml
```

## Screenshots

**Jenkins — Pipeline Success**
<img width="1362" height="681" alt="Screenshot_7" src="https://github.com/user-attachments/assets/4b32e42a-03ac-425f-9c5a-8aeae0ef0a9a" />

**EC2 Inctanace  && EKS Cluster**
<img width="1362" height="602" alt="Screenshot_6" src="https://github.com/user-attachments/assets/f52eb40b-ce94-4a9e-9615-cd7a49367e9b" />

**App Live on Browser**
<img width="1364" height="684" alt="Screenshot_4" src="https://github.com/user-attachments/assets/16c8e0f9-e6f7-4029-8a63-8d8f3c422c03" />


---

## API Endpoints

| Endpoint | Response |
|---|---|
| `GET /` | App info, version, environment, timestamp |
| `GET /health` | `{ "status": "healthy", "uptime": ... }` |


---

## Key Learnings

- Setting up Jenkins on AWS EC2 from scratch
- GitHub Webhook integration for auto-trigger on every push
- Dockerizing a Node.js application with health checks
- Pushing Docker images to AWS ECR using IAM Role (no hardcoded credentials)
- Creating and managing AWS EKS cluster with eksctl
- Writing Helm charts for Kubernetes deployments
- Nginx Ingress for traffic routing via AWS Load Balancer
- Zero-downtime rolling deployments with Kubernetes

---

## Author

**Akash Ahirwar** — DevOps Enthusiastic

[![GitHub](https://github.com/akash-ahirwar02/cicd-demo-app)

If you found this helpful, please ⭐ star this repository!
