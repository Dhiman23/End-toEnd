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
    }
}