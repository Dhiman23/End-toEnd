@Library('my-shared-library') _

pipeline{
    agent any
    parameters{
        choice(name: 'action',choices: 'create\ndelete', description: 'Choose create/destroy')
        string(name: 'aws_account_id',description: "AWS Account ID",defaultValue: '073372031334')
         string(name: 'Region',description: "name of the docker build",defaultValue: 'us-east-1')
          string(name: 'ECR_REPO_NAME',description: "name of the ECR",defaultValue: 'endtoend')
         string (name: 'cluster', defaultValue: 'demo-cluster',description: 'Eks cluster')
         string (name: 'region', defaultValue: 'us-east-1',description: 'Eks cluster')
    }
    environment{
        ACCESS_KEY = credentials('AWS_Key')
        SECRET_KEY = credentials('AWS_Key_S')
     
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

             stage('Create EKS Cluster : Terraform'){
          
            steps{
                script{
                  dir('eks_module'){
                    sh '''
                       terraform init
                       terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SCERET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars
                       terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SCERET_KEY'  -var 'region=${params.Region}' --var-file=./config/terraform.tfvars --auto-approve
                    '''
                  }
                }
            }
        }


            stage('eks connect'){
            steps{
                sh '''
                aws eks --region ${params.region} update-kubeconfig --name ${params.cluster}

                '''
            }
        }

                  stage('eks deployment'){
            
            steps{
                when{expression{ params.action== 'create'}}
                script{
                    def apply = false
                    try {
                        input message: 'please confirm the apply to innitiate the deployments',ok: 'Read to apply the config'
                        apply = true

                    }
                    catch(err){
                       apply = false
                       CurrentBuild.result= 'UNSTABLE'
                    }
                    if(apply){
                        sh "kubectl apply -f ."

                    }
                }
            }
        }
    }
}


    

