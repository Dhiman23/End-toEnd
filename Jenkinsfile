@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        choice(name: 'action',choices: 'create\ndelete',description: 'Choose create/Destroy')
    }

    stages{
        when{experssion {param.action == 'create'}}
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
            when{experssion {param.action == 'create'}}
            steps{
                script{
                    mvnTest()
                }
            }
        }
        stage('Intergration Test maven'){
            when{experssion {param.action == 'create'}}
            steps{
                script{
                    mvnIntegrationTest()
                }
            }
        }
        stage('Static code analysis: SonarQube'){
          when{experssion {param.action == 'create'}}
          steps{
            script{
                staticCodeAnalysis()
            }
          }
        }
    }
}