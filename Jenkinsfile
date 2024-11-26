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
                        scp  -r -o StrictHostKeyChecking=no ../code ec2-user@${PYTHON_NODE}:/tmp
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum install python3 -y; sudo cp /tmp/code/python_app.service /etc/systemd/system; sudo systemctl daemon-reload; sudo systemctl restart python_app.service'
                        """
                        
                    }
                }
            }
        }
        stage ('Terraform Format') { 
            steps {
                script { 
                        sh """
                        cd dev
                        terraform fmt -check  || echo "Terraform formatting is not correct, but continuing pipeline."
                        //holder1=\$?
                        //echo "\$holder1"
                        //terraform validate
                        //holder=\$?
                       // echo "\$holder"
                       // if [ \$holder -eq 0 ]; then
                       //    echo "Validation successful"
                      //  else
                      //     echo "Validation failed"
                     //   fi
                        """                        
                    }
                }
            }
        
        stage ('Pytest for Unit Testing') { 
            steps {
                script { 
                        sh """  
                        pytest hello.py      /

                        """                        
                    }
                }
            }
        }
    
        post{
            success{
                script {
                    withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_TOKEN')]) {
                   //withEnv(["SLACK_TOKEN=${SLACK_TOKEN}"]) {
                        sh """
                        curl -X POST \
                        -H 'Authorization: Bearer ${SLACK_TOKEN}' \
                        -H 'Content-Type: application/json' \
                        --data '{"channel": "devops-masterclass-2024","text" : "Kunle Oyeleye`s Project 10 Pipeline build was SUCCESSFUL...yeah!!!"}'  \
                        https://slack.com//api/chat.postMessage 
                            """
                            }
                }
            }
            failure{
                script{
                    withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_TOKEN')]) {
                    //withEnv(["SLACK_TOKEN=${SLACK_TOKEN}"]) {
                        sh """
                        curl -X POST \
                        -H 'Authorization: Bearer ${SLACK_TOKEN}' \
                        -H 'Content-Type: application/json' \
                        --data '{"channel": "devops-masterclass-2024","text" : "Kunle Oyeleye`s Project 10 Pipeline build FAILED...Check"}'  \
                        https://slack.com//api/chat.postMessage 
                            """
                            }
                }
            }
            always {
            echo 'I have finished'
            deleteDir() 
            }
        }
}
            
       
    
