pipeline {
    agent any

    environment {
        // ✅ ONLY use host:port or hostname for Docker login
        NEXUS_HOST = "http://0.0.0.0:8081/#admin/repository/repositories:docker-repo"
        IMAGE_NAME = "${NEXUS_HOST}/my-app"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        NEXUS_CREDENTIALS_ID = "nexus-id"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIALS_ID}",
                                                  usernameVariable: 'NEXUS_USER',
                                                  passwordVariable: 'NEXUS_PASS')]) {
                        sh "docker login -u $NEXUS_USER -p $NEXUS_PASS ${NEXUS_HOST}"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
            sh "docker logout ${NEXUS_HOST}"
        }
    }
}
