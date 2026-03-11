pipeline {
agent any

```
environment {
    AWS_REGION = "ap-south-1"
    ECR_REPO = "776751404462.dkr.ecr.ap-south-1.amazonaws.com/springboot-devops-app"
}

stages {

    stage('Clone Repository') {
        steps {
            git 'https://github.com/yalamuri-babu/springboot-platform-demo.git'
        }
    }

    stage('Build JAR') {
        steps {
            sh './mvnw clean package'
        }
    }

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t springboot-demo .'
        }
    }

    stage('Tag Image') {
        steps {
            sh 'docker tag springboot-demo:latest $ECR_REPO:latest'
        }
    }

    stage('Push to ECR') {
        steps {
            sh '''
            aws ecr get-login-password --region $AWS_REGION | \
            docker login --username AWS --password-stdin $ECR_REPO
            docker push $ECR_REPO:latest
            '''
        }
    }

}
```

}
