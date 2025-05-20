pipeline {
    agent any

    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "0.0.0.0:8081"           // Your Nexus host:port
        NEXUS_REPOSITORY = "docker-repo"  // Your Docker repo in Nexus
        NEXUS_CREDENTIAL_ID = "nexus_id"    // Jenkins credential ID for Nexus
    }

    parameters {
        string(name: 'RELEASE_VERSION', defaultValue: "1.0.${env.BUILD_NUMBER}", description: 'Version to release')
    }

    stages {
        stage("Clone code from GitHub") {
            steps {
                git branch: 'main', url: 'https://github.com/Salhianis1/nexus-docker.git'
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    // Compose full image name: e.g. 0.0.0.0:8081/docker-hosted/myapp:1.0.42
                    def imageName = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
                    docker.build(imageName)
                }
            }
        }

        stage("Login to Nexus Docker Registry") {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIAL_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    script {
                        sh """
                            echo "$NEXUS_PASS" | docker login ${NEXUS_URL} -u $NEXUS_USER --password-stdin
                        """
                    }
                }
            }
        }

        stage("Push Docker Image") {
            steps {
                script {
                    def imageName = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
                    sh "docker push ${imageName}"
                }
            }
        }

        stage("Logout from Nexus") {
            steps {
                script {
                    sh "docker logout ${NEXUS_URL}"
                }
            }
        }
    }
}
