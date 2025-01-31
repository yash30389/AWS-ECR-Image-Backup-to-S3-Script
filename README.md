
# AWS-ECR-Image-Backup-to-S3-Script

This Bash script automates the process of backing up Docker images from Amazon Elastic Container Registry (ECR) to an S3 bucket. The script performs the following tasks:

- **Docker Authentication**: It authenticates Docker with AWS ECR using the `aws ecr get-login-password` command.
- **Repository Processing**: For each repository specified in the script, it retrieves all the image tags associated with that repository.
- **Image Pulling and Saving**: For each image tag, the script pulls the Docker image from ECR, saves it as a tarball (.tar file), and uploads the tarball to the specified S3 bucket in the correct directory structure.
- **Cleanup**: The script removes the local tarball file after the upload and optionally removes the Docker images to free up space.

### Prerequisites:
- AWS CLI configured with appropriate permissions.
- Docker installed and configured on the system.
- An S3 bucket for storing the tarball backups.
- Access to the specified AWS ECR repositories.

### Usage:
- Set the required environment variables such as AWS region, S3 bucket name, repository names, and AWS account ID.
- Run the script to back up Docker images from ECR to S3.
