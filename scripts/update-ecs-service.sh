#!/bin/bash
set -e

CLUSTER_NAME=$1
SERVICE_NAME=$2
TASK_FAMILY=$3
AWS_REGION=$4

echo "Updating ECS service..."
echo "Cluster: $CLUSTER_NAME"
echo "Service: $SERVICE_NAME"
echo "Task family: $TASK_FAMILY"

LATEST_REVISION=$(aws ecs describe-task-definition \
  --task-definition "$TASK_FAMILY" \
  --region "$AWS_REGION" \
  --query 'taskDefinition.revision' \
  --output text)

echo "Latest revision: $LATEST_REVISION"

aws ecs update-service \
  --cluster "$CLUSTER_NAME" \
  --service "$SERVICE_NAME" \
  --task-definition "$TASK_FAMILY:$LATEST_REVISION" \
  --region "$AWS_REGION"

echo "ECS service updated successfully"
