@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        choice(name: 'action',choices: 'create\ndelete', description: 'Choose create/destroy')
        string(name: 'aws_account_id',description: "AWS Account ID",defaultValue: '073372031334')
         string(name: 'Region',description: "name of the docker build",defaultValue: 'us-east-1')
          string(name: 'ECR_REPO_NAME',description: "name of the ECR",defaultValue: 'endtoend')
    }
    environment{
        access_key = credentials('AWS_Key')
        secret_key = credentials('AWS_Key_S')
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
                    dockerImagePush("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
                }
            }
        
          
        stage('Docker Iamge Cleanup : ECR'){
            when{expression{ params.action== 'create'}}
            steps{
                script{
                    dockerImageCleanup("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }

        stage('Create EKS Cluster : Terrform'){
            steps{
                script{
                    dir('eks_module') {
                       
                       sh'terraform init'
                       sh'terraform plan -var "access-key=$access_key" -var "secret_key=$secret_key" -var "region=${params.Region}" -var-file=./config/terraform.tfvars'
                       sh'terraform apply -var "access-key=$access_key" -var "secret_key=$secret_key" -var "region=${params.Region}" -var-file=./config/terraform.tfvars --auto-approve'
                       
                   }
                }
            }
        }
    }
}


    

