#!groovy

  pipeline {
    agent {
      label 'r-slave'
    }
    stages{
      stage('Install dependencies') {
        steps {
          echo 'installing dependencies'
          sh """
            #!/bin/bash
            set -ex
            sudo Rscript -e "install.packages(c('curl', 'tibble', 'testthat'), repos='https://cran.rstudio.com')"
            R CMD INSTALL . --library=/usr/lib/R/site-library || { export STATUS=failed
            exit 1
            }
          """
        }
      }
      stage('Build - clinPK') {
        steps {
          echo 'building clinPK'
          sh """
            R CMD build --no-manual --no-build-vignettes .
            find . -type f -name 'clinPK_*.tar.gz' | xargs R CMD check --no-manual --no-build-vignettes
            rm -rf clinPK_*.tar.gz
          """
        }
      }
    }
    post {
      failure {
        sh "chmod +x slack_notification.sh"
        sh "/bin/bash slack_notification.sh"
    }
  }
  environment {
      KHALEESI_SLACK_TOKEN = credentials('KHALEESI_SLACK_TOKEN')
      JENKINS_SLACKBOT = credentials('JENKINS_SLACKBOT')
  }
}
