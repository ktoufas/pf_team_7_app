pipeline{
    agent any
    tools{
        maven "maven-3.6.1"
    }
    stages{
        stage("Development Branch"){
            when{
                branch 'development'
            }
            steps{
                echo "Development Branch Steps"                
                sh "ansible devservers -m ping --private-key ~/.ssh/pf6-keypair.pem"
            }
        }
        stage("Production Branch"){
            when{
                branch 'production'
            }
            steps{
                echo "Production Branch Steps"
                sh "ansible webservers -m ping"
            }

        }
    }
}