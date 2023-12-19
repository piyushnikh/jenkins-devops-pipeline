pipeline {
    agent any
    environment {
        Docker_Image_Name = "myimage"
        Docker_Tag = "v2"
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10')
        disableConcurrentBuilds()
    }
    stages {
        stage ('Pre-Checks') {
            parallel {
                stage('Docker-Verify') {
                steps {
                retry(3) {
                    sh 'docker --version'
                    }
                    }
                }
                stage('Git-Verify') {
                    steps {
                        sh 'git --version'
                    }
                }
            }
        }
        stage('Docker-Build') {
            when {
                branch 'main'
            }
            steps {
                sh 'docker build -t "$Docker_Image_Name":"$BUILD_NUMBER" .'
                sh 'docker inspect "$Docker_Image_Name":"$BUILD_NUMBER"'
            }
        }
        stage('Docker-Build-Verify') {
            steps {
                sh 'docker images'
            }
        }
        stage('Docker-Deploy') {
            sh '''
            docker run -itd  -p 80:80 ${Docker_Image_Name}:${BUILD_NUMBER}
            docker ps
            '''
        }
    }
}
