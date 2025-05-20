pipeline {
    agent any

    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "http://0.0.0.0:8081"           // Nexus host:port, HTTP assumed
        NEXUS_REPOSITORY = "docker-repo"
        NEXUS_CREDENTIAL_ID = "nexus_id"
    }

    parameters {
        string(name: 'RELEASE_VERSION', defaultValue: "1.0.0", description: 'Version to release')
    }

    stages {
        stage('Prepare Version') {
            steps {
                script {
                    env.FINAL_VERSION = "${params.RELEASE_VERSION}.${env.BUILD_NUMBER}"
                    currentBuild.displayName = "#${env.BUILD_NUMBER} - Release ${env.FINAL_VERSION}"
                }
            }
        }

        stage('Clone code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/Salhianis1/nexus-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${env.FINAL_VERSION}"
                    docker.build(imageName)
                    env.IMAGE_NAME = imageName
                }
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIAL_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    // Use single quotes to avoid Groovy interpolation of secrets
                    sh 'echo $NEXUS_PASS | docker login $NEXUS_URL -u $NEXUS_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Logout from Nexus') {
            steps {
                sh 'docker logout $NEXUS_URL'
            }
        }
    }
}
