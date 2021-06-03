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
                //sh "ansible-playbook /etc/ansible/dev_playbook.yml --limit devservers"  
            }
            post{
                success{
                    emailext(

                        subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                 <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        recipientProviders: [[$class: 'buildUser']]
                    )
                }
                failure{
                    emailext(
                        subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                 <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        recipientProviders: [culprits(), requestor()]
                    )
                }
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