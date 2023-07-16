@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        choice(name: 'action',choices: 'create\ndelete', description: 'Choose create/destroy')
        string(name: 'ImageName',description: "name of the docker build",defaultvalue: 'javapp')
         string(name: 'ImageTag',description: "name of the docker build",defaultvalue: 'v1')
          string(name: 'AppName',description: "name of the Application",defaultvalue: 'springboot')
    }
   

    stages{
        
        stage('Git checkout'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                   gitCheckout(
                    branch: "main",
                    url: "https://github.com/Dhiman23/End-toEnd.git"
                   )
                }
            }
        }

        stage('Unit Test Maven'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    mvnTest()
                }
            }
        }
        stage('Intergration Test maven'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    mvnIntegrationTest()
                }
            }
        }
        stage('Static code analysis: SonarQube'){
           when{expression{ params.action== 'create'}}
           steps{
            script{
                def SonarQubecredentialsId = 'sonar-api' 
                statiCodeAnalysis(SonarQubecredentialsId)
            }
          }
        }

        stage('Quality Gate Status Check : Sonarqube'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    def SonarQubecredentialsId = 'sonar-api'
                    QualityGateStatus(SonarQubecredentialsId)
                }
            }
        }
        stage('Maven Build : maven'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    mvnBuild()
                }
            }
        }

         stage('Docker Image Build'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerBuild("${params.ImageName}","${params.ImageTag}","${params.AppName}")
                }
            }
        }
         

         
    }
}