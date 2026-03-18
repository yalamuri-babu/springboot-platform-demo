pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID  = '776751404462'
        AWS_REGION      = 'ap-south-1'
        APP_NAME        = 'springboot-devops-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        GIT_REPO        = 'https://github.com/yalamuri-babu/springboot-platform-demo.git'
        GIT_BRANCH      = 'main'
        VALUES_FILE     = 'helm/springboot-app/values-dev.yaml'
        FULL_IMAGE_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

       stage('Build JAR') {
    steps {
        sh '''
          chmod +x mvnw
          ./mvnw clean package -DskipTests
        '''
    }
}

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t ${APP_NAME}:${IMAGE_TAG} .
                '''
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

        stage('Push Image to ECR') {
            steps {
                sh '''
                  docker tag ${APP_NAME}:${IMAGE_TAG} ${FULL_IMAGE_REPO}:${IMAGE_TAG}
                  docker push ${FULL_IMAGE_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Update Helm Values in Git') {
            steps {
                sh '''
                  export FULL_IMAGE_REPO="${FULL_IMAGE_REPO}"
                  export IMAGE_TAG="${IMAGE_TAG}"

                  if command -v yq >/dev/null 2>&1; then
                    yq -i '.image.repository = env(FULL_IMAGE_REPO)' ${VALUES_FILE}
                    yq -i '.image.tag = env(IMAGE_TAG)' ${VALUES_FILE}
                  else
                    sed -i 's|^[[:space:]]*repository:.*|  repository: '"${FULL_IMAGE_REPO}"'|' ${VALUES_FILE}
                    sed -i 's|^[[:space:]]*tag:.*|  tag: "'"${IMAGE_TAG}"'"|' ${VALUES_FILE}
                  fi

                  echo "Updated ${VALUES_FILE}:"
                  cat ${VALUES_FILE}
                '''
            }
        }

        stage('Commit and Push Git Change') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jenkins-git-PAT',
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_PASSWORD'
                )]) {
                    sh '''
                      git config user.name "jenkins"
                      git config user.email "jenkins@local"

                      git add ${VALUES_FILE}

                      git diff --cached --quiet && echo "No changes to commit" && exit 0

                      git commit -m "Update dev image to ${IMAGE_TAG} [skip ci]"

                      git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/yalamuri-babu/springboot-platform-demo.git
                      git push origin ${GIT_BRANCH}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Image pushed to ECR: ${FULL_IMAGE_REPO}:${IMAGE_TAG}"
            echo "Git updated successfully. Argo CD should sync from Git."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}