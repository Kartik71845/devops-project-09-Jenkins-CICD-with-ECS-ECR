#!/bin/bash
set -e
echo "DEBUG:"       
echo "CLUSTER_NAME=$1"
echo "TASK_FAMILY=$2"
echo "IMAGE_URI=$3"
echo "AWS_REGION=$4"

echo "Registering new task definition..."

aws ecs describe-task-definition \
  --task-definition "$TASK_FAMILY" \
  --region "$AWS_REGION" \
  --query 'taskDefinition' > old-task-def.json

jq '
  del(
    .taskDefinitionArn,
    .revision,
    .status,
    .requiresAttributes,
    .compatibilities,
    .registeredAt,
    .registeredBy
  )
  | .containerDefinitions[0].image = "'"$IMAGE_URI"'"
' old-task-def.json > new-task-def.json

aws ecs register-task-definition \
  --cli-input-json file://new-task-def.json \
  --region "$AWS_REGION"

echo "New task definition registered successfully"
