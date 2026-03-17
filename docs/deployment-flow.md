# Deployment Flow

## GitOps Flow
1. Developer updates code or Helm values in VS Code
2. Changes are committed and pushed to GitHub
3. Argo CD detects the Git change
4. Argo CD syncs manifests to EKS
5. Kubernetes updates the workload

## Runtime Path
GitHub → Argo CD → Helm → EKS → Service → Application

## Validation Commands
- kubectl get applications -n argocd
- kubectl get pods -n dev
- kubectl get pods -n staging
- kubectl get pods -n prod
- kubectl get svc -n prod
- curl http://<prod-load-balancer>