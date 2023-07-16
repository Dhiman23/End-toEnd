@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        choice(name: 'action',choices: 'create\ndelete', description: 'Choose create/destroy')
        string(name: 'aws_account_id',description: "AWS Account ID",defaultValue: '073372031334')
         string(name: 'Region',description: "name of the docker build",defaultValue: 'us-east-1')
          string(name: 'ECR_REPO_NAME',description: "name of the ECR",defaultValue: 'sajaldhimanitc1999')
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

         stage('Docker Image Build: ECR'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerBuild("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }
         stage('Docker Image Scan: trivy'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerImageScan("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }
        stage('Docker Iamge push : ECR'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerImagePush("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                }
            }
        }
          }
        stage('Docker Iamge Cleanup : ECR'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerIamgeCleanup("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }

         
    }
}