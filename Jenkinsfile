pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = 'latest'
        NEXUS_URL = 'localhost:8083'          // Nexus Docker connector URL with correct port
        DOCKER_CREDENTIALS_ID = 'nexus_id'           // Jenkins credentials ID for Nexus
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
                    def fullImageName = "${NEXUS_URL.replace('http://', '')}/${IMAGE_NAME}:${IMAGE_TAG}"
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
