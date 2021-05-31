pipeline{
    agent any
    tools{
        maven "maven-3.6.1"
    }
    stages{
        stage("Hello World"){
            when{
                branch 'development'
            }
            steps{
                echo "Hello World"                
                sh "ansible devservers -m ping --private-key /home/ec2-user/.ssh/pf6-keypair_J.pem -u ec2-user"
                
            }
        }        
    }
}