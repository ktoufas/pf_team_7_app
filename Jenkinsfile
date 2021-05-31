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
                sh "ansible devservers -m ping"
            }
        }        
    }
}