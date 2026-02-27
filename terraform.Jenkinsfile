pipeline {
    agent any 

    stages{

        stage('Git') {
            steps {
                checkout scm
            }
        }
        stage('Terraform init') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '--entrypoint=""'
                }
            }
            steps {
                sh '''
                    terraform --version
                    terraform init -input=false
                '''
            }
        }
    }
}