pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-1'
        AWS_ACCOUNT_ID = '647800544853'
        ECR_REPO_NAME  = 'ecs-static-site'

        ECS_CLUSTER    = 'jenkins-ecs-cluster'
        ECS_SERVICE    = 'jenkins-ecs-service'
        TASK_FAMILY    = 'jenkins-ecs-task'

        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME   = "${ECR_REPO_NAME}"
        IMAGE_TAG    = "build-${env.BUILD_NUMBER}"
        FULL_IMAGE   = "${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Deploy to AWS (ECR + ECS)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-ecr-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        set -e

                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}

                        echo "== Verifying AWS credentials =="
                        aws sts get-caller-identity

                        echo "== Login to ECR =="
                        aws ecr get-login-password --region ${AWS_REGION} \
                          | docker login --username AWS --password-stdin ${ECR_REGISTRY}

                        echo "== Build Docker image =="
                        docker build -t ${FULL_IMAGE} .

                        echo "== Push image to ECR =="
                        docker push ${FULL_IMAGE}

                        echo "== Register ECS task definition =="
                        ./scripts/register-task-def.sh \
                          ${ECS_CLUSTER} \
                          ${TASK_FAMILY} \
                          ${FULL_IMAGE} \
                          ${AWS_REGION}

                        echo "== Update ECS service =="
                        ./scripts/update-ecs-service.sh \
                          ${ECS_CLUSTER} \
                          ${ECS_SERVICE} \
                          ${TASK_FAMILY} \
                          ${AWS_REGION}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "===== ECS Deployment Finished Successfully ====="
        }
        failure {
            echo "===== ECS Deployment Failed ====="
        }
    }
}
