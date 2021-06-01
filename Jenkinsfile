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
                sh "ansible-playbook /etc/ansible/dev_playbook.yml --limit devservers"
            }
        }
        stage("Production Branch"){
            when{
                branch 'production'
            }
            steps{
                echo "Production Branch Steps"
                sh "ansible prodservers -m ping"
            }

        }
    }
}