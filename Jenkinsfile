@Library('my-shared-library') _

pipeline{
    agent any
   

    stages{
        
        stage('Git checkout'){
            
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
            
            steps{
                script{
                    mvnTest()
                }
            }
        }
        stage('Intergration Test maven'){
            
            steps{
                script{
                    mvnIntegrationTest()
                }
            }
        }
        stage('Static code analysis: SonarQube'){
           
           steps{
            script{
                def SonarQubecredentialsId = 'sonar-api' 
                statiCodeAnalysis(SonarQubecredentialsId)
            }
          }
        }

        stage('Quality Gate Status Check : Sonarqube'){
            steps{
                script{
                    def SonarQubecredentialsId = 'sonar-api'
                    QualityGateStatus(SonarQubecredentialsId)
                }
            }
        }
        stage('Maven Build : maven'){
            steps{
                script{
                    mvnBuild()
                }
            }
        }

    }
}