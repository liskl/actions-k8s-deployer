# actions-k8s-deployer

Blantant Ripoff of: https://github.com/kodermax/kubectl-aws-eks, moved to here for runtime code security, _only run code you control and have went over._

This action provides `kubectl` for Github Actions.

## Usage

`.github/workflows/push.yml`

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-2

    - name: deploy to cluster
      uses: liskl/actions-k8s-deployer@main
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA_STAGING }}
        REGISTRY: registry.infra.liskl.com
        REPOSITORY: /liskl/app
        APP: application
        TAG: ${{ github.sha }}
      with:
        args: set image deployment/$APP $APP=$REGISTRY/$REPOSITORY:$TAG

    - name: verify deployment
      uses: liskl/actions-k8s-deployer@main
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        APP: application
      with:
        args: rollout status deployment/$APP
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```