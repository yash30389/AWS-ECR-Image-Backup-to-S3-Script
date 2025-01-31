#!/bin/bash

# Variables
AWS_REGION="ap-southeast-1"    # As per AWS specified given name
S3_BUCKET_NAME=""              # AWS bucket name where the ecr backup's are stored
REPOSITORIES=""                # Write one or more repository name like "repo1 repo2 repo3"
AWS_ACCOUNT_ID=""              # AWS account ID
REGION_NAME=""                 # Noramal Region name in words

# Authenticate Docker with ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com

# Process each repository
for REPO in $REPOSITORIES; do
    echo "Processing repository: $REPO"

    # Replace "/" with "\" in the repository name for the S3 directory
    S3_DIR=$(echo $REPO | sed 's/\//\\/g')

    # Get all image tags for the repository
    IMAGE_TAGS=$(aws ecr list-images --repository-name $REPO --region $AWS_REGION --query "imageIds[].imageTag" --output text)

    for TAG in $IMAGE_TAGS; do
        echo "Saving image: $REPO:$TAG"

        # Define the tar file name and S3 path
        TAR_FILE="${REPO}_${TAG}.tar"
        S3_PATH="${REGION_NAME}/${S3_DIR}/${TAG}.tar"

        echo "Tarfile name: $TAR_FILE"
        echo "S3 Path: $S3_PATH"

        # Pull the image
        docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO:$TAG

        # Save the image to a tar file
        docker save -o $TAR_FILE ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO:$TAG

        # Upload the tar file to S3
        aws s3 cp $TAR_FILE s3://$S3_BUCKET_NAME/$S3_PATH

        # Remove the local tar file to save space
        rm -rf $TAR_FILE

        # Remove Docker images to save space (optional, uncomment if needed)
        docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO:$TAG
    done
done
