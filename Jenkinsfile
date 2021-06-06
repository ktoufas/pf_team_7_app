pipeline{
    environment{
        dockerImage = ''
        registry = 'ktoufas/to_do_app'
        version = '3.0.0'
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
                        failure{
                            emailext(
                                subject: "FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                                body: """FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]:
                                        Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>""",
                                recipientProviders: [culprits()] //SEND EMAIL TO THE PERSON WHOSE COMMIT TRIGGERED THE BUILD
                            )
                        }
                    }     
                }
                stage("Create docker image"){
                    steps{
                            sh "docker build -t ${registry}:${version} --file Dockerfile.dev ."                   
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
                    }
                }
            }
            post{
                success{
                    emailext(
                        subject: "SUCCESSFUL: Deployment to development environment | ${env.JOB_NAME} | BUILD NUMBER: [${env.BUILD_NUMBER}]",
                        body: "SUCCESSFUL: Deployment to development environment | ${env.JOB_NAME} | BUILD NUMBER: [${env.BUILD_NUMBER}]",
                        recipientProviders: [culprits()]
                    )
                }
                failure{
                    emailext(
                        subject: "FAILURE: Deployment to development environment | '${env.JOB_NAME}| BUILD NUMBER: [${env.BUILD_NUMBER}]'",
                        body: """FAILURE: Deployment to development environment | ${env.JOB_NAME}| BUILD NUMBER: [${env.BUILD_NUMBER}]
                                Check console output at ${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]""",
                        recipientProviders: [culprits()] 
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
                            }
                        }

                    }
                }
                stage("Create docker image"){
                    steps{
                        sh "docker build -t ${registry}:${version} --file Dockerfile.prod ."                   
                    }
                }
                stage("Deploy Verification"){
                    steps{
                        emailext(
                        subject: "Deployment verification: ${env.JOB_NAME}",
                        body: "Verify deployment to production at: ${env.BUILD_URL}input",
                        to: "ktoufas@gmail.com"
                        )
                        input("Are you sure you want to deploy the application?")
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
                        ansiblePlaybook(
                            playbook: "/etc/ansible/dev_playbook.yml", 
                            limit: "prodservers", 
                            extraVars: [
                                version: "${version}"
                            ])  
                    }
                }
            }
            post{
                success{
                    emailext(
                        subject: "SUCCESSFUL: Deployment to production",
                        body: "SUCCESSFUL: Deployment to production environment | ${env.JOB_NAME}",
                        to: "ktoufas@gmail.com"
                    )
                }
                failure{
                    emailext(
                        subject: "FAILURE: Deployment to production",
                        body: """FAILURE: Deployment to production environment | ${env.JOB_NAME}
                                Check console output at ${env.BUILD_URL}""",
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
                            }
                        }

                    }    
                }
            }          
        }
    }
}
