
pipeline {
    agent any

    environment {
        NEXUS_URL = "localhost:8081" 
        NEXUS_REPOSITORY = "repository/docker-repo"
        NEXUS_CREDENTIAL_ID = "nexus_id"  // Jenkins credential ID for Nexus username/password
    }

    parameters {
        string(name: 'RELEASE_VERSION', defaultValue: "1.0.${BUILD_NUMBER}", description: 'Version to release')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Salhianis1/nexus-docker.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    IMAGE_NAME = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
                    echo "Building Docker image: ${IMAGE_NAME}"
                    docker.build(IMAGE_NAME)
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIAL_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        echo "$NEXUS_PASS" | docker login ${NEXUS_URL} -u "$NEXUS_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image: ${IMAGE_NAME}"
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('Docker Logout') {
            steps {
                sh "docker logout ${NEXUS_URL}"
            }
        }
    }
}
