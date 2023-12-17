pipeline {
    agent any
    environment {
        Docker_Image_Name = "myimage"
        Docker_Tag = "v2"
    }
    stages {
        stage('Docker-Verify') {
            steps {
               sh 'doker --version'
               options {
                    retry(3)
                }
            }
        }
        stage('Git-Verify') {
            steps {
               sh 'git --version'
            }
        }
        stage('Docker-Build') {
            steps {
                sh 'docker build -t "$Docker_Image_Name":"$BUILD_NUMBER" .'
            }
        }
        stage('Docker-Build-Verify') {
            steps {
                sh 'docker images'
            }
        }
    }
}
