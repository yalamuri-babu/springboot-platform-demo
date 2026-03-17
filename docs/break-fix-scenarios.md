# Break/Fix Scenarios

## 1. Argo CD app was Synced but not Healthy
### Symptom
Application showed Synced but Progressing or Degraded.

### Cause
Argo CD successfully applied manifests, but Kubernetes workloads were unhealthy.

### Troubleshooting
- kubectl get applications -n argocd
- kubectl get pods -n <namespace>
- kubectl describe pod <pod-name> -n <namespace>
- kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

### Fix
Resolved the underlying Kubernetes issue such as scheduling or image configuration.

---

## 2. Too many pods on single-node EKS
### Symptom
Pod remained Pending.

### Event
0/1 nodes are available: 1 Too many pods

### Cause
Single worker node reached pod capacity during multi-environment rollout.

### Fix
- reduced replicaCount to 1
- disabled HPA
- disabled PDB
- used ClusterIP for non-prod environments

---

## 3. ImagePullBackOff
### Symptom
Pod failed to start with image pull errors.

### Cause
Wrong image tag or malformed Helm values.

### Troubleshooting
- kubectl describe pod <pod-name> -n <namespace>
- kubectl get deployment springboot-app -n <namespace> -o yaml

### Fix
Corrected image repository/tag in values file and pushed fix to Git.

---

## 4. Malformed Helm values YAML
### Symptom
Unexpected deployment behavior after Git push.

### Cause
Invalid YAML structure in values file.

### Fix
Corrected indentation and proper nested keys, then validated with:
- helm lint
- helm template

---

## 5. Metrics API not available
### Symptom
kubectl top nodes returned:
error: Metrics API not available

### Cause
metrics-server was not installed.

### Fix
Installed metrics-server and verified with:
- kubectl get pods -n kube-system | grep metrics-server
- kubectl top nodes

---

## 6. HPA validation in staging
### Goal
Validate autoscaling safely in a non-prod environment.

### Steps
- enabled HPA only in staging
- verified metrics-server
- checked HPA object
- observed CPU target and replica count

### Result
HPA created successfully and metrics were available.