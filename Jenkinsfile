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
               sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 475798544865.dkr.ecr.ap-south-1.amazonaws.com'
               sh 'docker build -t my-jenkins-project:"$BUILD_NUMBER" .'
               sh 'docker tag my-jenkins-project:"$BUILD_NUMBER" 475798544865.dkr.ecr.ap-south-1.amazonaws.com/my-jenkins-project:"$BUILD_NUMBER"'
               sh 'docker push 475798544865.dkr.ecr.ap-south-1.amazonaws.com/my-jenkins-project:"$BUILD_NUMBER"'
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
               docker run -itd -p 80:80 475798544865.dkr.ecr.ap-south-1.amazonaws.com/my-jenkins-project:"$BUILD_NUMBER"
               docker ps
               '''
            }  
        }
        stage('Prod-Deploy') {
            input {
               message 'Do you want to proceed for production deployment ?'
            }
            steps {
                sh '''
                sshpass -p "31278600aA@" ssh pn02398@13.233.90.9 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 475798544865.dkr.ecr.ap-south-1.amazonaws.com'
                sshpass -p "31278600aA@" ssh pn02398@13.233.90.9 'docker run -d -p 80:80 475798544865.dkr.ecr.ap-south-1.amazonaws.com/my-jenkins-project:"$BUILD_NUMBER"'
                '''
            }  
        }
    }
    post {
        always {
            sh 'docker ps'
        }
        failure {
            sh 'docker rm -f $(docker ps -a -q) 2> /dev/null'
        }
        success {
            sh 'curl localhost'
        }
        cleanup {
            sh 'docker image prune -af'
        } 
    }    
}
