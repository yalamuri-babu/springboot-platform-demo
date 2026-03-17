# Cost Optimization Decisions

## Cluster Design
- single-node EKS cluster used for learning and testing
- replicas reduced to 1 in all environments for stability

## Service Exposure
- dev uses ClusterIP
- staging uses ClusterIP
- prod uses LoadBalancer

## Scaling
- HPA tested only temporarily in staging
- HPA disabled afterward to avoid unnecessary scheduling pressure

## Operational Strategy
- GitOps workflow used to make cluster reproducible
- cluster can be simplified or destroyed after testing to avoid extra cost