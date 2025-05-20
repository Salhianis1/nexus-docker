pipeline {
    agent any

    environment {
        NEXUS_REPO = 'http://0.0.0.0:8081/docker-hosted/docker-repo'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        NEXUS_CREDENTIALS_ID = 'nexus_id'
    }

    def dockerImage

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
                script {
                    def registryHost = env.NEXUS_REPO.split('/')[0]
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIALS_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                        sh '''
                            echo $NEXUS_PASS | docker login ${registryHost} -u $NEXUS_USER --password-stdin
                        '''
                    }
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
                script {
                    def registryHost = env.NEXUS_REPO.split('/')[0]
                    sh "docker logout ${registryHost}"
                }
            }
        }
    }
}
