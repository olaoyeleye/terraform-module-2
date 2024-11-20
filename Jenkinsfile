pipeline {
    agent any 
    environment {
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
    }
    stages {
        stage ('Manage Nginx') {
            environment {
                  //NGINX_NODE2 = sh(script: "cd dev; terraform output  |  grep nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                  NGINX_NODE2 =data.terraform_remote_state.remote.public_dns
            }
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        env
                        cd dev
                        echo "test"
                        echo "${NGINX_NODE2}"
                        
                                             
                        """
                        //ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE2} 'pwd'
                    }
                }
            }
        }  
       
    }
}