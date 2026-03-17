# RBAC

Implemented namespace-scoped RBAC for dev environment.

## Access Model
- ServiceAccount: dev-reader
- Namespace: dev
- Permissions:
  - get/list/watch pods
  - get/list/watch services
  - get/list/watch deployments
  - no delete/update permissions
  - no access to prod namespace

## Validation
Used `kubectl auth can-i` to confirm least-privilege access.