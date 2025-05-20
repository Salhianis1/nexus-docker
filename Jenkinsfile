pipeline {
    agent any

    environment {
        NEXUS_URL = "0.0.0.0:8085"        // No protocol
        NEXUS_REPOSITORY = "docker-repo"
        NEXUS_CREDENTIAL_ID = "nexus_id"  // Your Jenkins credentials ID
    }

    parameters {
        string(name: 'RELEASE_VERSION', defaultValue: "1.0.${env.BUILD_NUMBER}", description: 'Version to release')
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
                    def imageName = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
                    docker.build(imageName)
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIAL_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        echo "$NEXUS_PASS" | docker login ${NEXUS_URL} -u $NEXUS_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
                    sh "docker push ${imageName}"
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
