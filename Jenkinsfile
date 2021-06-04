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
                stage("Build application"){
                    stages{
                        stage("Clean old mvn output"){
                            steps{
                                sh "mvn clean"
                            }
                        }
                        stage("Unit Tests"){
                            steps{
                                sh "mvn test"
                            }
                        }
                        stage("Compile source code"){
                            steps{
                                sh "mvn clean compile"
                            }
                        }
                        stage("Package application"){
                            steps{
                                sh "mvn package -DoutputDirectory=/home/ec2-user/jenkins_output/"
                            }
                        }

                    }
                    post{
                        success{
                            emailext(
                                subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                                recipientProviders: [developers()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD culprits()
                            )
                        }
                        failure{
                            emailext(
                                subject: "FAILUR: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                                recipientProviders: [culprits()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
                            )
                        }
                    }     
                }
                stage("Create docker image"){
                    steps{
                        echo "Creating docker image with development db link"
                    }
                }
                stage("Push image to repository"){
                    steps{
                        echo "Pushing image to repository"
                    }

                }
                stage("Deploy application"){
                    steps{
                        echo "Development Branch Steps"                
                        //sh "ansible-playbook /etc/ansible/dev_playbook.yml --limit devservers"  
                    }
                }
            }
            post{
                success{
                    emailext(
                        subject: "SUCCESSFUL: Deployment '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>SUCCESSFUL: Deployment '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        to: "ktoufas@gmail.com" //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
                    )
                }
                failure{
                    emailext(
                        subject: "FAILUR: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        to: "ktoufas@gmail.com" //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
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
                //sh "ansible prodservers -m ping"
            }

        }
    }
}
