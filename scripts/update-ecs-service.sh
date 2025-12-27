#!/bin/bash
set -e

CLUSTER_NAME=$1
SERVICE_NAME=$2
TASK_FAMILY=$3
AWS_REGION=$4

echo "Updating ECS service..."

LATEST_REVISION=$(aws ecs describe-task-definition \
  --task-definition "$TASK_FAMILY" \
  --region "$AWS_REGION" \
  --query 'taskDefinition.revision' \
  --output text)

aws ecs update-service \
  --cluster "$CLUSTER_NAME" \
  --service "$SERVICE_NAME" \
  --task-definition "$TASK_FAMILY:$LATEST_REVISION" \
  --region "$AWS_REGION"

echo "ECS service updated to revision $LATEST_REVISION"
