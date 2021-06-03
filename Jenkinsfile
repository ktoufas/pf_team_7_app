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
            stages{
                stage("Clean old mvn output"){
                    
                }
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
                        recipientProviders: [requestor()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
                    )
                }
                failure{
                    emailext(
                        subject: "FAILUR: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                 <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        recipientProviders: [culprits(), requestor()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
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