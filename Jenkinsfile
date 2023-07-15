@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        Choice(name: 'action',choices: 'create\ndelete', description: 'Choose create/destroy')
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
         

         
    }
}