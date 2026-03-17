# Architecture

This project demonstrates a real-world DevOps / Platform Engineering workflow on AWS EKS.

## Components
- Spring Boot application
- Docker image build
- Amazon ECR for image storage
- Helm chart for Kubernetes packaging
- Argo CD for GitOps deployment
- Amazon EKS cluster for runtime
- Separate environments: dev, staging, prod

## Deployment Flow
- Source code stored in GitHub
- Changes pushed to GitHub
- Argo CD watches GitHub repository
- Helm chart rendered with environment-specific values
- Kubernetes resources applied to EKS

## Environments
- dev: ClusterIP, 1 replica
- staging: ClusterIP, 1 replica
- prod: LoadBalancer, 1 replica

## Features Implemented
- readinessProbe
- livenessProbe
- resource requests and limits
- metrics-server installation
- HPA tested in staging