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
            cd /$workspace
            if [ -d "clinPK2" ]; then
              sudo rm -R clinPK2
            fi
            git clone git@github.com:InsightRX/clinPK2.git
            cd clinPK2
            git checkout $GIT_BRANCH
            chmod +x slack_notification.sh
            R CMD INSTALL . --library=/usr/lib/R/site-library || { export STATUS=failed
            ./slack_notification.sh
            exit 1
            }
            R CMD check . --no-manual || { export STATUS=failed
            ./slack_notification.sh
            exit 1
            }
          """
        }
      }
    }
  }
