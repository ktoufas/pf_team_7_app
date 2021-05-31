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
                echo "Hello World!"
                sh "sudo ansible devservers -m ping --private-key .ssh/pf6-keypair.pem"
            }
        }        
    }
}