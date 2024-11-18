pipeline {
    agent any 
    environment {
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
    }
    stages {
        stage('Initialise terraform') {
            steps {
                sh '''
                cd dev
                terraform init -reconfigure
                '''
            }
        }
        stage('Terraform Plan ') {
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=nginx' -var 'node2=python-node'
                '''
            }
        }  
        stage('Terraform Apply ') {
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=nginx' -var 'node2=python-node' -auto-approve
                '''
            }
        }
        stage ('Manage Nginx') {
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        env
                        cd dev
                        echo "test"
                        NGINX_NODE1 = sh "terraform output  |  grep nginx "
                        echo "${NGINX_NODE1}"
                        ssh  ec2-user@${NGINX_NODE1} 'pwd'
                       
                        """
                        
                    }
                }
            }
        }     
    }
}