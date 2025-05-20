pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-app'                         // Name of the Docker image
        IMAGE_TAG = 'latest'                          // Tag for the image
        NEXUS_URL = '0.0.0.0:8081'          // Nexus Docker registry URL
        NEXUS_REPO = 'docker-hosted'                  // Nexus repository name (Docker hosted)
        DOCKER_CREDENTIALS_ID = 'nexus-_id'  // Jenkins credentials ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: "${DOCKER_CREDENTIALS_ID}",
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )]) {
                        sh """
                        echo "$NEXUS_PASS" | docker login ${NEXUS_URL} -u "$NEXUS_USER" --password-stdin
                        """
                    }
                }
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
                script {
                    def fullImageName = "${NEXUS_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${fullImageName}"
                    sh "docker push ${fullImageName}"
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker logout ${NEXUS_URL}"
            }
        }
    }
}
