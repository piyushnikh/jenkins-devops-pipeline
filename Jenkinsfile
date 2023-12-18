pipeline {
    agent any
    options {
        skipDefaultCheckout true
        timestamps
    }
    environment {
        Docker_Image_Name = "myimage"
        Docker_Tag = "v2"
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
    }
}
