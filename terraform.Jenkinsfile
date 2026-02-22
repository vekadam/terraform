pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }    
        }

        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Manual approval') {
            steps {
                input message: "Do you want to approve Terraform apply?"
            }
        }

        stage('Terraform apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}