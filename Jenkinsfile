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
                echo $PWD
                //sh "ansible devservers -m ping --private-key .ssh/pf6-keypair.pem"
                echo $WORKSPACE
            }
        }        
    }
}