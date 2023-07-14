@Library('my-shared-libary') _

pipeline{
    agent any

    stages{
        stage('Git checkout'){
            steps{
                script{
                   gitCheckout(
                    branch: "master",
                    url: "https://github.com/Dhiman23/End-toEnd.git"
                   )
                }
            }
        }
    }
}