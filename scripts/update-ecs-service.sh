#!/bin/bash
set -e

CLUSTER_NAME=$1
SERVICE_NAME=$2
TASK_FAMILY=$3
AWS_REGION=$4

echo "DEBUG:"
echo "CLUSTER_NAME=$CLUSTER_NAME"
echo "SERVICE_NAME=$SERVICE_NAME"
echo "TASK_FAMILY=$TASK_FAMILY"
echo "AWS_REGION=$AWS_REGION"

echo "Fetching latest task revision..."

LATEST_REVISION=$(aws ecs describe-task-definition \
  --task-definition "$TASK_FAMILY" \
  --region "$AWS_REGION" \
  --query 'taskDefinition.revision' \
  --output text)

echo "Latest revision: $LATEST_REVISION"

echo "Resolving ECS service ARN..."

SERVICE_ARN=$(aws ecs describe-services \
  --cluster "$CLUSTER_NAME" \
  --services "$SERVICE_NAME" \
  --region "$AWS_REGION" \
  --query 'services[0].serviceArn' \
  --output text)

if [ "$SERVICE_ARN" = "None" ] || [ -z "$SERVICE_ARN" ]; then
  echo "ERROR: ECS service '$SERVICE_NAME' not found in cluster '$CLUSTER_NAME'"
  exit 1
fi

echo "Service ARN: $SERVICE_ARN"

echo "Updating ECS service..."

aws ecs update-service \
  --cluster "$CLUSTER_NAME" \
  --service "$SERVICE_ARN" \
  --task-definition "$TASK_FAMILY:$LATEST_REVISION" \
  --region "$AWS_REGION"

echo "ECS service updated successfully"
