#!/bin/bash
set -e

CLUSTER_NAME=$1
TASK_FAMILY=$2
IMAGE_URI=$3
AWS_REGION=$4

echo "DEBUG:"
echo "CLUSTER_NAME=$CLUSTER_NAME"
echo "TASK_FAMILY=$TASK_FAMILY"
echo "IMAGE_URI=$IMAGE_URI"
echo "AWS_REGION=$AWS_REGION"

echo "Fetching existing task definition..."

aws ecs describe-task-definition \
  --task-definition "$TASK_FAMILY" \
  --region "$AWS_REGION" \
  --query 'taskDefinition' > old-task-def.json

echo "Updating container image in task definition..."

jq --arg IMAGE "$IMAGE_URI" '
  del(
    .taskDefinitionArn,
    .revision,
    .status,
    .requiresAttributes,
    .compatibilities,
    .registeredAt,
    .registeredBy
  )
  | .containerDefinitions |= map(.image = $IMAGE)
' old-task-def.json > new-task-def.json

echo "Registering new task definition..."

aws ecs register-task-definition \
  --cli-input-json file://new-task-def.json \
  --region "$AWS_REGION"

echo "New task definition registered successfully"
