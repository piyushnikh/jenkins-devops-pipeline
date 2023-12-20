pipeline {
    agent any
    environment {
        Docker_Image_Name = "myimage"
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '3')
        disableConcurrentBuilds()
    }
    stages {
        stage ('Pre-Checks') {
            parallel {
                stage('Docker-Verify') {
                steps {
                    sh 'docker --version'
                    }
                }
                stage('Git-Verify') {
                    steps {
                        sh 'git --version'
                    }
                }
            }
        }
        stage('Docker-CleanUp') {
             steps {
                sh 'docker rm -f "$(docker ps -a -q)"'
            }
        }
        stage('Docker-Build') {
            steps {
                sh 'dockers build -t "$Docker_Image_Name":"$BUILD_NUMBER" .'
                sh 'docker inspect "$Docker_Image_Name":"$BUILD_NUMBER"'
            }
        }
        stage('Docker-Build-Verify') {
            steps {
                sh 'docker images'
            }
        }
        stage('Docker-Deploy') {
            input {
               message 'Do you want to proceed for deployment ?'
            }
            steps {
               sh '''
               docker run -itd  -p 80:80 ${Docker_Image_Name}:${BUILD_NUMBER}
               docker ps
                '''
            }  
        }
        stage('Docker-Images-CleanUp') {
            steps {
                sh 'docker image prune -af'
            }
        }
    }
    post {
        always {
            sh 'docker ps'
        }
    }
        failure {
            sh 'docker rm -f \$(sudo docker ps -a -q) 2> /dev/null || true'
        } 
}
