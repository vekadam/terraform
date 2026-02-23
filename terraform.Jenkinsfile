pipeline {
    agent any 

    stages{
        stage('Terraform init') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-u root'
                }
            }
            steps {
                checkout scm
                sh '''
                    terraform --version
                    terraform init -input=false
                '''
            }
        }
    }
}