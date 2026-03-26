pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_ACCOUNT_ID        = credentials('AWS_ACCOUNT_ID')
        AWS_REGION            = 'us-east-2'
        ECR_REPO              = 'cicd-demo-app'
        IMAGE_TAG             = "${BUILD_NUMBER}"
        CLUSTER_NAME          = 'cicd-cluster'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '==> Code GitHub se pull ho raha hai...'
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                echo '==> Dependencies install aur test chal raha hai...'
                sh '''
                    npm install
                    node server.js &
                    sleep 3
                    node test.js
                    pkill -f "node server.js" || true
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo '==> Docker image build ho rahi hai...'
                sh '''
                    ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_URI}:latest
                '''
            }
        }

        stage('ECR Push') {
            steps {
                echo '==> Image ECR pe push ho rahi hai...'
                sh '''
                    ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
                    aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin \
                        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    docker push ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo '==> EKS pe deploy ho raha hai...'
                sh '''
                    ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
                    aws eks update-kubeconfig \
                        --region ${AWS_REGION} \
                        --name ${CLUSTER_NAME}
                    helm upgrade --install cicd-demo-app ./helm/cicd-demo-app \
                        --set image.repository=${ECR_URI} \
                        --set image.tag=${IMAGE_TAG} \
                        --namespace production \
                        --create-namespace
                '''
            }
        }

    }

    post {
        success {
            echo '✅ Pipeline SUCCESS! App deploy ho gayi!'
        }
        failure {
            echo '❌ Pipeline FAILED! Logs dekho upar.'
        }
        always {
            sh 'docker system prune -f || true'
        }
    }
}
