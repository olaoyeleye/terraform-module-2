pipeline {
    agent any 
    environment {
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
    }
    parameters{
        choice(choices:"ALL\nINFRA\nAPP\nTEST\nDESTROY", description: "Pipeline branches options",name: "DEPLOY_OPTIONS")
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
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=nginx' -var 'node2=python-node-1' -var 'node3=python-node-2'
                '''
            }
        }  
        stage('Terraform Apply ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=nginx' -var 'node2=python-node-1' -var 'node3=python-node-2' -auto-approve
                '''
            }
        }
          
        stage('Terraform Destroy ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'DESTROY' }
            }
            steps {
                sh '''
                cd dev
                terraform destroy -var 'node1=nginx' -var 'node2=python-node-1' -var 'node3=python-node-2' -auto-approve
                '''
            }
        }
        stage('Test python file before upload') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'TEST' }
            }
            steps {
                sh '''
                cd dev
                find ./code/hello.py -type f -exec echo "Python file (hello.py) exists"  || echo "Python file (hello.py) does not exist"
                apt install python3-venv
                python3 -m venv myenv
                . myenv/bin/activate
                pip install pytest
                pytest ./code/hello.py
                '''
            }
        } 

        stage ('Manage APP') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'APP' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            environment {
                  NGINX_NODE = sh(script: "cd dev; terraform output  |  grep nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                  PYTHON_NODE_1 = sh(script: "cd dev; terraform output  |  grep python-1 | awk -F\\=  '{print \$2}'",returnStdout: true).trim()        
                  PYTHON_NODE_2 = sh(script: "cd dev; terraform output  |  grep python-2 | awk -F\\=  '{print \$2}'",returnStdout: true).trim()        
           
            }

            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        cd dev
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} 'sudo yum install -y nginx && sudo systemctl start nginx'
                        scp  -r -o StrictHostKeyChecking=no ../code ec2-user@${PYTHON_NODE_1}:/tmp
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE_1} 'ls -ltar /tmp/code; sudo yum install python3 -y; sudo cp /tmp/code/python_app.service /etc/systemd/system; sudo systemctl daemon-reload; sudo systemctl restart python_app.service'
                        
                        scp  -r -o StrictHostKeyChecking=no ../code ec2-user@${PYTHN_NODE_2}:/tmp
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHN_NODE_2} 'ls -ltar /tmp/code; sudo yum install python3 -y; sudo cp /tmp/code/python_app.service /etc/systemd/system; sudo systemctl daemon-reload; sudo systemctl restart python_app.service'
                        """
                        
                    }
                }
            }
        }
        stage ('Terraform Format') { 
            when {
                expression  { params.DEPLOY_OPTIONS == 'APP' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                script { 
                        sh """
                        cd dev
                        terraform fmt -check  || echo "Terraform formatting is not correct, but continuing pipeline."                        
                        """                        
                    }
                }
            }
        stage ('Terraform Validate') { 
            when {
                expression  { params.DEPLOY_OPTIONS == 'APP' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                script { 
                        sh """
                        cd dev
                        terraform validate  || echo "Terraform Validate is not correct, but continuing pipeline."                        
                        """                        
                    }
                }
            }
       
        stage ('Pytest for Unit Testing') { 
            when {
                expression  { params.DEPLOY_OPTIONS == 'APP' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            environment {
                PYTHON_NODE_1 = sh(script: "cd dev; terraform output  |  grep python-1 | awk -F\\=  '{print \$2}'",returnStdout: true).trim()        
                PYTHON_NODE_2 = sh(script: "cd dev; terraform output  |  grep python-2 | awk -F\\=  '{print \$2}'",returnStdout: true).trim()  
            } 
            steps {
                script { 
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """                        
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE_1} 'sudo yum update -y; sudo yum install -y python3-pip; pip3 install pytest; pytest /tmp/code/hello.py '
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE_2} 'sudo yum update -y; sudo yum install -y python3-pip; pip3 install pytest; pytest /tmp/code/hello.py '
                        """                        
                    }
                    
                }
            }
        }
    } 
        post{
            success{
                script {
                    echo "Success"
               /*     withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_TOKEN')]) {
                   //withEnv(["SLACK_TOKEN=${SLACK_TOKEN}"]) {
                        sh """
                        curl -X POST \
                        -H 'Authorization: Bearer ${SLACK_TOKEN}' \
                        -H 'Content-Type: application/json' \
                        --data '{"channel": "devops-masterclass-2024","text" : "Kunle Oyeleye`s Project 10 Pipeline build was SUCCESSFUL...yeah!!!"}'  \
                        https://slack.com//api/chat.postMessage 
                            """
                            }*/
                }
            }
            failure{
                script{
                    echo "Failed"
                  /*  withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_TOKEN')]) {
                    //withEnv(["SLACK_TOKEN=${SLACK_TOKEN}"]) {
                        sh """
                        curl -X POST \
                        -H 'Authorization: Bearer ${SLACK_TOKEN}' \
                        -H 'Content-Type: application/json' \
                        --data '{"channel": "devops-masterclass-2024","text" : "Kunle Oyeleye`s Project 10 Pipeline build FAILED...Check"}'  \
                        https://slack.com//api/chat.postMessage 
                            """
                            }*/
                }
            }
            always {
            echo 'I have finished'
            deleteDir() 
            sh """
            echo "I have finished and cleaned up all repo created"
            rm -rf venv
            """
            }
        }
}
            
       
    
