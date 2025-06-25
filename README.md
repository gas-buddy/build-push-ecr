# build-push-ecr

This GitHub action builds a container that will run a node app (via `npm start`), pushes it to Amazon ECR, and optionally supports GitHub Container Registry (GHCR) integration. The base image (gasbuddy/node-app) has some opinions about ports and such, so if you're not at GasBuddy and you're using this step, it's probably as inspiration and not directly.

## Usage

```yaml
- name: Build and push Docker image
  uses: gas-buddy/build-push-ecr@v12
  with:
    # Required inputs
    registry-name: your-registry/your-image
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    
    # Optional inputs
    aws-region: us-east-1  # Default: us-east-1
    image-tag: ${{ github.run_id }}_${{ github.sha }}  # Default: github.run_id_github.sha
    node-env: production  # Default: not set
    node-image-tag: 14-production  # Default: 14-production
    npm-token: ${{ secrets.NPM_TOKEN }}  # Default: ""
    skip-build: false  # Default: false
    apk_packages: "package1 package2"  # Default: ""
    ghcr-username: ${{ github.actor }}  # Default: ""
    ghcr-password: ${{ secrets.GITHUB_TOKEN }}  # Default: ""
```

> **Note**: If GHCR credentials are not provided as inputs, login to GHCR must be done before calling this composite action, otherwise action will fail to pull private GHCR images during the build process.

## Workflow Steps

1. **GHCR Login** (Conditional): Logs into GitHub Container Registry if both `ghcr-username` and `ghcr-password` are provided.

2. **Set NPM_TOKEN** (Conditional): Sets the NPM_TOKEN environment variable if `npm-token` is provided.

3. **Build Docker Image** (Conditional): Builds a Docker image using the Dockerfile from the action. Can be skipped by setting `skip-build` to `true`.

4. **Unset AWS Token**: Unsets the AWS_SESSION_TOKEN environment variable.

5. **Push to ECR**: Pushes the built Docker image to Amazon ECR.
