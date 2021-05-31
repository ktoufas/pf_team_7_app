pipeline{
    agent any
    tools{
        maven "maven-3.0.5"
    }
    stages{
        stage("Hello World"){
            when{
                branch 'development'
            }
            steps{
                echo "Hello World"
            }
        }        
    }
}