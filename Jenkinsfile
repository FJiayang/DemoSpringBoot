pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('clone code') {
      agent {
        none {
          label 'maven'
        }

      }
      steps {
        container('base') {
          git(url: 'https://github.com/FJiayang/DemoSpringBoot.git', credentialsId: 'github-id', branch: '2.1.6.RELEASE', changelog: true, poll: false)
        }

      }
    }

    stage('default-1') {
      parallel {
        stage('unit test') {
          agent {
            none {
              label 'maven'
            }

          }
          steps {
            container('maven') {
              sh 'mvn clean test'
            }

          }
        }

        stage('sonar-check') {
          agent {
            none {
              label 'maven'
            }

          }
          steps {
            container('maven') {
              withCredentials([string(credentialsId : 'sonar-token' ,variable : 'SONAR_TOKEN' ,)]) {
                withSonarQubeEnv('sonar') {
                  sh 'mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN -Dsonar.projectKey=demo-springboot'
                }

              }

              timeout(unit: 'HOURS', activity: true, time: 1) {
                waitForQualityGate 'false'
              }

            }

          }
        }

      }
    }

    stage('build & push') {
      agent {
        none {
          label 'maven'
        }

      }
      steps {
        container('maven') {
          sh 'mvn -Dmaven.test.skip=true clean package'
          sh 'docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER .'
          withCredentials([usernamePassword(passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,credentialsId : "$DOCKER_CREDENTIAL_ID" ,)]) {
            sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
            sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER'
          }

        }

      }
    }

    stage('push latest') {
      agent {
        none {
          label 'maven'
        }

      }
      when {
        branch 'master'
      }
      steps {
        container('maven') {
          sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:latest '
          sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:latest '
        }

      }
    }

    stage('deploy to dev') {
      agent {
        none {
          label 'maven'
        }

      }
      when {
        environment name: 'DEPLOY', value: 'true'
      }
      steps {
        input(id: 'deploy-to-dev', message: 'deploy to dev?')
        kubernetesDeploy(configs: 'deploy/dev-ol/**', enableConfigSubstitution: true, kubeconfigId: "$KUBECONFIG_CREDENTIAL_ID")
      }
    }

    stage('deploy to production') {
      agent none
      when {
        environment name: 'ENV', value: 'PROD'
      }
      steps {
        input(id: 'deploy-to-production', message: 'deploy to production?')
        kubernetesDeploy(configs: 'deploy/prod-ol/**', enableConfigSubstitution: true, kubeconfigId: "$KUBECONFIG_CREDENTIAL_ID")
      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITHUB_CREDENTIAL_ID = 'github-id'
    KUBECONFIG_CREDENTIAL_ID = 'demo-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'fjy8018'
    GITHUB_ACCOUNT = 'kubesphere'
    APP_NAME = 'demo-springboot'
    SONAR_CREDENTIAL_ID = 'sonar-token'
  }
  parameters {
    string(name: 'DEPLOY', defaultValue: 'false', description: '是否部署')
  }
}