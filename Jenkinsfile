pipeline {
    agent any

    environment {
        registry = 'salhianis20/web-app'
        registryCredential = 'dockerhub-id'
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/Salhianis1/web-app.git', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.registry}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withVault(
                        configuration: [
                            vaultCredentialId: 'vault-cred',
                            vaultUrl: 'http://127.0.0.1:8200',
                            timeout: 60,
                            disableChildPoliciesOverride: false
                        ],
                        vaultSecrets: [[
                            path: 'secret/dockercred',
                            secretValues: [
                                [envVar: 'DOCKER_USERNAME', vaultKey: 'username'],
                                [envVar: 'DOCKER_PASSWORD', vaultKey: 'pwd']
                            ]
                        ]]
                    ) {
                        // Login and push
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                        dockerImage.push()
                        sh 'docker logout'
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh """
                        docker rm -f web-app-container || true
                        docker run -d --name web-app-container -p 8084:80 ${env.registry}:${env.BUILD_NUMBER}
                    """
                }
            }
        }
    }
}
