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
            when{experssion { params.action == 'create'}}
            steps{
                script{
                    mvnIntegrationTest()
                }
            }
        }
        stage('Static code analysis: SonarQube'){
           
           steps{
            script{
                def SonarQubecredentialId = 
                staticCodeAnalysis(SonarQubecredentialId)
            }
          }
        }

    }
}