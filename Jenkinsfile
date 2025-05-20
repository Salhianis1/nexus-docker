pipeline {
    agent any

    environment {
        // Nexus Docker repo URL
        NEXUS_REPO = 'nexus.example.com:8083/myproject/myapp'
        IMAGE_TAG = "1.0"
        // Jenkins credential ID for Nexus login
        NEXUS_CREDENTIALS_ID = 'nexus-docker-credentials'
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
                    dockerImage = docker.build("${NEXUS_REPO}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIALS_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh "echo $NEXUS_PASS | docker login ${NEXUS_REPO.split('/')[0]} -u $NEXUS_USER --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Logout from Nexus') {
            steps {
                sh "docker logout ${NEXUS_REPO.split('/')[0]}"
            }
        }
    }
}
