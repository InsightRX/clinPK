#!groovy

  pipeline {
    agent {
      label 'r-slave'
    }
    stages{
      stage('Dependencies - build json2test') {
        steps {
          echo 'building json2test'
          sh """
            #!/bin/bash
            set -ex
            pwd
            sudo chmod 777 ~/workspace
            cd ~/workspace
            if [ -d "json2test" ]; then
              sudo rm -R json2test
            fi
            echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.rstudio.com'; options(repos = r);" > ~/.Rprofile
            Rscript -e "install.packages('testthat')"
            git clone git@github.com:InsightRX/json2test.git
            cd json2test
            chmod +x slack_notification.sh
            R CMD INSTALL . --library=/usr/lib/R/site-library || { export STATUS=failed
            ./slack_notification.sh
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
