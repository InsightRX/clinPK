#!groovy

pipeline {
  agent {
    label 'docker-runner'
  }
  stages{
    stage('Run docker container') {
      environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
      }
      steps {
        echo "Running irx-r-base container"
        sh """
        \$(aws ecr get-login --no-include-email --region us-west-2 &> /dev/null)
        docker run -dt --name ${BUILD_TAG} 579831337053.dkr.ecr.us-west-2.amazonaws.com/irx-r-base:latest
        """
      }
    }
    stage('Build & test clinPK') {
      steps {
        echo 'Installing and checking clinPK'
        sh """
        docker cp . ${BUILD_TAG}:/src/clinPK
        docker exec -i ${BUILD_TAG} Rscript -e "devtools::check('clinPK')"
        """
      }
    }
  }
  post {
    always {
      sh """
      docker rm -f ${BUILD_TAG} &>/dev/null && echo 'Removed container'
      """
    }
    failure {
      sh "chmod +x slack_notification.sh"
      sh "./slack_notification.sh"
    }
  }
  environment {
    KHALEESI_SLACK_TOKEN = credentials('KHALEESI_SLACK_TOKEN')
    JENKINS_SLACKBOT = credentials('JENKINS_SLACKBOT')
  }
}
