pipeline {
  environment {
    imagename = "vasylyshyn1984/test-jenkins-demo"
    registryCredential = 'Docker-Hub-vasylyshyn1984'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'git@github.com:williyamino/jenkins-docker-test.git', branch: 'main', credentialsId: 'jenkins-5'])
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
    stage('SSH transfer') {
        steps{
            sshPublisher(
                continueOnError: false, failOnError: true,
                publishers: [
                    sshPublisherDesc(
                        configName: "web-srv",
                        verbose: true,
                        transfers: [
                            sshTransfer(execCommand:  "docker stop jenkins-demo-app || true && docker rm jenkins-demo-app || true && docker pull vasylyshyn1984/test-jenkins-demo && docker run -d --name jenkins-demo-app -p 81:80 vasylyshyn1984/test-jenkins-demo"),
                        ]
                    )
                ]
            )
        }
    }
  }
}