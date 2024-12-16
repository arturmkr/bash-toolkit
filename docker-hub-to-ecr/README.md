# Docker Hub to AWS ECR Utility

This Bash script pulls a Docker image from Docker Hub and pushes it to an AWS Elastic Container Registry (ECR). It handles multi-architecture images (AMD64 and ARM64) and creates the ECR repository if it does not exist.

## Features
- Pulls Docker images for AMD64 and ARM64 architectures.
- Tags images for AWS ECR compatibility.
- Pushes images to AWS ECR.
- Creates the ECR repository if it does not already exist.

---

## Requirements
- AWS CLI must be installed and configured with the required profile.
- Docker CLI must be installed and running.

---

## Usage

Run the script with the following arguments:
```bash
./docker-hub-to-ecr.sh <source_repo> <image_tag> <destination_image_name> <aws_profile> <docker_registry>
```

### Parameters:
1. **`source_repo`**: The source Docker repository (e.g., `nginx` or `docker.io/library/nginx`).
2. **`image_tag`**: The tag of the image to pull (e.g., `latest` or `1.21.1`).
3. **`destination_image_name`**: The name of the image in the AWS ECR repository.
4. **`aws_profile`**: The AWS CLI profile to use for authentication.
5. **`docker_registry`**: The AWS ECR registry URL (e.g., `123456789012.dkr.ecr.us-west-2.amazonaws.com`).

---

## Example

### Pull and Push an Image
To pull the `nginx:latest` image from Docker Hub and push it to an ECR repository:

```bash
./docker-hub-to-ecr.sh nginx latest nginx my-aws-profile 123456789012.dkr.ecr.us-west-2.amazonaws.com
```

### What Happens:
1. **Login to AWS ECR**:
   - Authenticates Docker with the AWS ECR registry using the specified profile.

2. **Pull and Tag Images**:
   - Pulls both AMD64 and ARM64 versions of the image from the source repository.
   - Tags the images for ECR.

3. **Create or Check Repository**:
   - Ensures the ECR repository exists, creating it if necessary.

4. **Push Images**:
   - Pushes the AMD64 and ARM64 images to ECR.
   - Creates and pushes a multi-architecture manifest.

---

## Notes
- Ensure you have the required permissions in AWS to create ECR repositories and push images.
- The `docker_registry` should match your AWS region (e.g., `123456789012.dkr.ecr.us-west-2.amazonaws.com` for `us-west-2`).

---
