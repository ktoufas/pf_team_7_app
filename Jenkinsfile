pipeline{
    environment{
        dockerImage = ''
        registry = 'ktoufas/to_do_app'
        version = '2.9.8'
    }
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
                                sh "mvn clean package"
                            }
                        }

                    }
                    post{
                        success{
                            emailext(
                                subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                                recipientProviders: [culprits()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD culprits()
                            )
                        }
                        failure{
                            emailext(
                                subject: "FAILUR: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                                recipientProviders: [culprits()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
                            )
                        }
                    }     
                }
                stage("Create docker image"){
                    steps{
                            sh "docker build -t ${registry}:${version} --build-arg DB_HOST=development-rds.cinmmc08wjk8.eu-west-1.rds.amazonaws.com ."                   
                    }
                }
                stage("Push image to repository"){
                    steps{
                        script{
                            docker.withRegistry('','dockerRegistry'){
                                sh "docker push ${registry}:${version}"
                            }
                        }

                    }
                }
                stage("Deploy application"){
                    steps{            
                        //sh "ansible-playbook /etc/ansible/dev_playbook.yml -e 'version=${version}' --limit devservers"
                        ansiblePlaybook(
                            playbook: "/etc/ansible/dev_playbook.yml", 
                            limit: "devservers", 
                            extraVars: [
                                version: "${version}"
                            ])
                        /*
                        ansiblePlaybook("/etc/ansible/dev_playbook.yml"){
                            limit("devservers")
                            extraVars {
                                extraVar("version","${version}")
                            }
                        }
                        */
                    }
                }
            }
            post{
                success{
                    emailext(
                        subject: "SUCCESSFUL: Deployment to development'${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>SUCCESSFUL: Deployment '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                    <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                        to: "ktoufas@gmail.com"
                    )
                }
                failure{
                    emailext(
                        subject: "FAILUR: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                        to: "ktoufas@gmail.com" 
                    )
                }
            }             
        }
        stage("Production Branch"){
            when{
                branch 'production'
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
                                sh "mvn package"
                                 //${WORKSPACE} Here will find the jar file and dockerfile
                            }
                        }

                    }
                    post{
                        success{
                            emailext(
                                subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                                to: "ktoufas@gmail.com" //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD culprits()
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
                stage("Create docker image"){
                    steps{
                        echo "Creating docker image with development db link"
                    }
                }
                stage("Deploy Verification"){
                    steps{
                        input("Are you sure you want to deploy the application?")
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
                        //sh "ansible-playbook /etc/ansible/dev_playbook.yml --limit prodservers"  
                    }
                }
            }
            post{
                success{
                    emailext(
                        subject: "SUCCESSFUL: Deployment to production '${env.JOB_NAME}'",
                        body: """<p>SUCCESSFUL: Deployment '${env.JOB_NAME}':</p>
                                    <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                        to: "ktoufas@gmail.com"
                    )
                }
                failure{
                    emailext(
                        subject: "FAILED: Deployment to production '${env.JOB_NAME}'",
                        body: """<p>FAILED: Deployment to production '${env.JOB_NAME}':</p>
                                <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                        to: "ktoufas@gmail.com"
                    )
                }
            }             
        }
        stage("PR Branch"){
            when{
                branch 'PR**'
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
                                sh "mvn package"
                                 //${WORKSPACE} Here will find the jar file and dockerfile
                            }
                        }

                    }
                    post{
                        success{
                            emailext(
                                subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                                body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                                        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                                to: "ktoufas@gmail.com" //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD culprits()
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
            }          
        }
    }
}
