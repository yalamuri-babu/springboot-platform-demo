pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '776751404462'
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/springboot-devops-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build JAR') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t springboot-devops-app:${IMAGE_TAG} .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                  aws ecr get-login-password --region ${AWS_REGION} | \
                  docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Tag and Push Image') {
            steps {
                sh '''
                  docker tag springboot-devops-app:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                  docker tag springboot-devops-app:${IMAGE_TAG} ${ECR_REPO}:latest
                  docker push ${ECR_REPO}:${IMAGE_TAG}
                  docker push ${ECR_REPO}:latest
                '''
            }
        }
    }
}