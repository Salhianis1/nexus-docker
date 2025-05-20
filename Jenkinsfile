pipeline {
    agent any
    environment {
        NEXUS_CREDS = credentials('nexus_id')
        NEXUS_DOCKER_REPO = 'localhost:8081'
    }

    stages {
         stage('SCM Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Salhianis1/nexus-docker.gi'
            //sh 'whoami'
            }
        } 
        
       stage('Docker Build') {
        
            steps { 
                    echo 'Building docker Image'
                    sh 'docker build -t $NEXUS_DOCKER_REPO/fakeweb:$BUILD_NUMBER .'
                }
        }

       stage('Docker Login') {
            steps {
                echo 'Nexus Docker Repository Login'
                script{
                    withCredentials([usernamePassword(credentialsId: 'nexus_creds', usernameVariable: 'USER', passwordVariable: 'PASS' )]){
                       sh ' echo $PASS | docker login -u $USER --password-stdin $NEXUS_DOCKER_REPO'
                    }
                   
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Imgaet to docker hub'
                sh 'docker push $NEXUS_DOCKER_REPO/fakeweb:$BUILD_NUMBER'
            }
        }
    }
}



// pipeline {
//     agent any

//     environment {
//         NEXUS_URL = "localhost:8081" 
//         NEXUS_REPOSITORY = "docker-repo"
//         NEXUS_CREDENTIAL_ID = "nexus_id"  // Jenkins credential ID for Nexus username/password
//     }

//     parameters {
//         string(name: 'RELEASE_VERSION', defaultValue: "1.0.${BUILD_NUMBER}", description: 'Version to release')
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 git url: 'https://github.com/Salhianis1/nexus-docker.git', branch: 'main'
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     IMAGE_NAME = "${NEXUS_URL}/${NEXUS_REPOSITORY}/myapp:${params.RELEASE_VERSION}"
//                     echo "Building Docker image: ${IMAGE_NAME}"
//                     docker.build(IMAGE_NAME)
//                 }
//             }
//         }

//         stage('Docker Login') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIAL_ID}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
//                     sh '''
//                         echo "$NEXUS_PASS" | docker login ${NEXUS_URL} -u "$NEXUS_USER" --password-stdin
//                     '''
//                 }
//             }
//         }

//         stage('Push Docker Image') {
//             steps {
//                 script {
//                     echo "Pushing Docker image: ${IMAGE_NAME}"
//                     sh "docker push ${IMAGE_NAME}"
//                 }
//             }
//         }

//         stage('Docker Logout') {
//             steps {
//                 sh "docker logout ${NEXUS_URL}"
//             }
//         }
//     }
// }
