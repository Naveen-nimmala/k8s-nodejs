node {

    stage("Checkout SourceCode"){
       git credentialsId: 'GITHUB_CRD', url: 'https://github.com/Naveen-nimmala/k8s-nodejs.git'
       /** Login details add with ID of GITHUB_CRD **/
    }
    stage ("Build Dcker Image"){
        docker build -t ${IMAGE_NAME}:${VERSION_PREFIX}${BUILD_NUMBER} ${WORKSPACE} -f Dockerfile
    }

    stage("dockerHub login"){
      withCredentials([usernamePassword(credentialsId: 'DOCKER_CRD', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]){
          sh 'docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}'
      }
    }

    stage("docker tag and Push"){   /** Once login successfull, it will push the latest image from DockerHuB **/
         sh  """
            docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${REGISTRY_URI}/${REGISTRY_NAME}/${IMAGE_NAME}:${GIT_BRANCH}-${BUILD_NUMBER}
            docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${REGISTRY_URI}/${REGISTRY_NAME}/${IMAGE_NAME}:${GIT_BRANCH}-${LATEST}
         """

            echo "Docker push"

         sh """
           docker push ${REGISTRY_URI}/${REGISTRY_NAME}/${IMAGE_NAME}:${GIT_BRANCH}-${BUILD_NUMBER}
           docker push ${REGISTRY_URI}/${REGISTRY_NAME}/${IMAGE_NAME}:${GIT_BRANCH}-${LATEST}
        """

    }
    stage("Deploy to Dev"){ /** We can install Kubectl on Jenkins node and configure the keys
    we can directly call the kubectl commands from Jenkins server to maket the changes in K8s cluster **/
                when {
                    branch 'dev'
                }
                steps {
                        sh '/bin/bash automate.sh -a'
                 }
                post{
                    success{
                        echo "Successfully deployed to development"
                    }
                    failure{
                        echo "Failed deploying to development"
                    }
                }
            }
    stage("Deploy to Production"){
                when {
                    branch 'master'
                }
                steps {
                        sh '/bin/bash automate.sh -a'
                 }
                post{
                    success{
                        echo "Successfully deployed to Production"
                    }
                    failure{
                        echo "Failed deploying to Production"
                    }
                }
            }
                post{
                    success{
                        echo "Successfully deployed to Production"
                    }
                    failure{
                        echo "Failed deploying to Production"
                    }
                }
            }

}
