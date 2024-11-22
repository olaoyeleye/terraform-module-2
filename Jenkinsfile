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
            environment {
                  NGINX_NODE = sh(script: "cd dev; terraform output  |  grep nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                  PYTHON_NODE = sh(script: "cd dev; terraform output  |  grep python | awk -F\\=  '{print \$2}'",returnStdout: true).trim()                   
                       
            }
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        cd dev
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} 'sudo yum install -y nginx && sudo systemctl start nginx'
                        #ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum update && sudo yum install -y ufw && sudo ufw allow out 22/tcp'
                        #ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT'
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum install -y python3'
                        
                        scp -o StrictHostKeyChecking=no hello.py ec2-user@${PYTHON_NODE}:/tmp/
                        #cd ../code
                        #ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} ' sudo yum install -y ufw && sudo ufw allow 65432/tcp'
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo install -y netstat && ss -tuln'
                        
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo lsof -i :'
                        
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'python3 /tmp/hello.py'
                        """
                        
                    }
                }
            }
        }  
       
    }
}