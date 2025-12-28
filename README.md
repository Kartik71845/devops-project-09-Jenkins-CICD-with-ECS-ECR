# 🚀 DevOps Project 09 — Jenkins CI/CD → AWS ECR → ECS (Fargate)

![Architecture Diagram]
![alt text](<Untitled (10)-1.gif>)

> End-to-end CI/CD pipeline that builds a Docker image, pushes it to AWS ECR, and deploys it to Amazon ECS using Fargate with zero downtime.

---

## 📌 Project Overview

This project demonstrates a **real-world Jenkins-based CI/CD pipeline** for containerized applications deployed on **AWS ECS (Fargate)**.

The goal was to:
- Automate Docker image builds
- Push images securely to AWS ECR
- Deploy applications to ECS without managing EC2 instances
- Achieve **rolling deployments with zero downtime**

---

## 🧩 Architecture Flow

Developer
↓
GitHub Repository
↓
Jenkins CI/CD Pipeline
├── Docker Build
├── Push Image to AWS ECR
├── Register new ECS Task Definition
└── Update ECS Service
↓
Amazon ECS (Fargate)
↓
End User

yaml
Copy code

---

## 🔧 What This Project Does

- Builds a Docker image for a static **Nginx application**
- Pushes the image to **AWS Elastic Container Registry (ECR)**
- Creates a **new ECS task definition revision** on every deployment
- Updates the **ECS service** to use the latest task
- Automatically stops old tasks **after** new tasks are running

✔ No EC2  
✔ No manual deployments  
✔ No downtime  

---

## 🔁 CI/CD Pipeline Workflow

1. Code is pushed to GitHub  
2. Jenkins pulls the latest source code  
3. Docker image is built inside Jenkins  
4. Image is pushed to AWS ECR  
5. ECS task definition is updated with the new image tag  
6. ECS service performs a rolling update  
7. New containers start before old ones stop  

---

## ⚙️ Deployment Behavior

- Each pipeline run creates a **new task revision**
- ECS handles rolling deployment automatically
- Old containers are terminated only after new ones become healthy
- The application remains accessible during deployments

---

## 🧠 Why ECS with Fargate?

- No server or cluster management
- No SSH access required
- Scales automatically
- Production-grade deployment model used by real teams

---

## 🛠 Tools & Services Used

- Jenkins
- Docker
- AWS ECR
- AWS ECS
- AWS Fargate
- AWS IAM
- GitHub

---

## 📂 Repository Structure

.
├── Dockerfile
├── Jenkinsfile
├── index.html
├── scripts/
│ ├── register-task-def.sh
│ └── update-ecs-service.sh
└── project-09-architecture.png

yaml
Copy code

---

## 🔒 Security Notes

- AWS credentials are managed using **Jenkins credentials**
- No secrets are hardcoded
- IAM permissions are scoped to ECS and ECR access only

---

## ✅ Outcome

- Fully automated CI/CD pipeline
- Zero-downtime deployments
- Clean separation of build and deployment stages
- Production-style AWS container deployment

---

## 📎 Notes

This project uses **manual Jenkins triggers**.  
GitHub webhooks were intentionally not added to avoid unnecessary deployments on non-application commits.

---

## 🔗 Related

Architecture diagram is included at the top of this README.
