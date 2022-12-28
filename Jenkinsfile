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
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:$BUILD_NUMBER"
         sh "docker rmi $imagename:latest"

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
                            sshTransfer(execCommand: """if [ ! "\$(docker ps -a -q -f name=jenkins-demo-app)" ]; then
                                                            if [ "\$(docker ps -aq -f status=exited -f name=jenkins-demo-app)" ]; then
                                                                # cleanup
                                                                docker rm jenkins-demo-app
                                                            fi
                                                            # run your container
                                                            docker run -d --name jenkins-demo-app -p 81:80 vasylyshyn1984/test-jenkins-demo
                                                        fi"""),
                        ]
                    )
                ]
            )
        }
    }
  }
}