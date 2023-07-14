@Library('my-shared-library') _

pipeline{
    agent any
    parameters {
  choice choices: ['create', 'delete'], description: 'create/delete', name: 'action'
   }

    stages{
        
        stage('Git checkout'){
            when{experssion { params.action == 'create'}}
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
            when{experssion { params.action == 'create'}}
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
           when{experssion { params.action == 'create'}}
           steps{
            script{
                staticCodeAnalysis()
            }
          }
        }

    }
}