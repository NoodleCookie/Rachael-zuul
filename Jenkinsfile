pipeline {
     agent any
     tools{
       maven "M3"
     }
    environment {
//         _project_name = "rachael-zuul"
//         _project_version = "1.0"
        _git_address = "https://github.com/NoodleCookie/${_github_project_name}.git"
        _harbor_address = "8.140.110.215:85"
        _harbor_project_name = "rachael"
        _credentialsId = "24d1ea7f-7c07-4eea-9f84-9a6298334aea"
    }

    stages {
             stage('Pull Code') {
                 steps{
                     sh "rm -rf ${env.WORKSPACE}/project/${_project_name}"
                     sh "mkdir -p ${env.WORKSPACE}/project/${_project_name}"
                     dir("${env.WORKSPACE}/project/${_project_name}") {
                         git "${_git_address}"
                         }
                    }
                 }

             stage('Compile'){
                     steps{
                         script{
                             dir("${env.WORKSPACE}/project/${_project_name}"){
                                 sh "mvn clean compile"
                             }
                         }
                     }
                 }

            stage("Build Jar") {
                        steps {
                            script {
                                dir("${env.WORKSPACE}/project/${_project_name}") {
                                    sh "mvn clean package"
                                }
                            }
                        }
                    }

            stage('Write Dockerfile') {
                             steps{
                                echo "==== Write Dockerfile start ===="
                                 dir("${env.WORKSPACE}/project/${_project_name}") {
                                    sh "rm -f Dockerfile"
                                    echo "== first remove dockerfile =="
                                     writeFile(
                                          file: "Dockerfile",
                                          text: """\
                                      FROM openjdk:11
                                      COPY ./target/${_github_project_name}-${_project_version}-SNAPSHOT.jar app.jar
                                      CMD ["java","-jar","/app.jar","-Dspring.profiles.active=\$(_active_profile)","--server.port=\$(port)"]
                                      """.stripIndent()
                                      )
                                      sh "cat -n Dockerfile"
                                      echo "==== Write Dockerfile finish ===="
                                     }
                                }
                             }

            stage("Build Image and Publish") {
                 steps {
                     script {
                        dir("/var/jenkins_home/workspace/deploy"){
                            // 删除容器和镜像
                             sh "chmod +x ./clean-container-image.sh"
                             sh "./clean-container-image.sh ${_project_name} ${_project_version}"
                        }


                         dir("${env.WORKSPACE}/project/${_project_name}") {
                            // 构建新镜像
                             sh "docker build -t ${_project_name}:${_project_version} ."
                             // push需要打上标签
//                              sh "docker tag ${_project_name}:${_project_version} ${_harbor_address}/${_harbor_project_name}/${_project_name}:${_project_version}"
                         }
                     }

                        // 推送到harbor
//                      script {
//                         withCredentials([usernamePassword(credentialsId: "${_credentialsId}", passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
//                             sh "docker login -u ${USERNAME} -p ${PASSWORD} ${_harbor_address}"
//                             sh "docker push ${_harbor_address}/${_harbor_project_name}/${_project_name}:${_project_version}"
//                         }

                       // 远程部署
//                         sshPublisher(publishers: [sshPublisherDesc(configName: 'Aliyun_server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: "/opt/jenkins_shell/deploy.sh ${_harbor_address} ${_harbor_project_name} ${_project_name} ${_project_version} ${port}", execTimeout: 0, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '', usePty: true)], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
//                      }

                     script {
                       dir("/var/jenkins_home/workspace/deploy") {
                            //本地部署
                            sh "chmod +x ./deploy-local.sh"
                            sh "./deploy-local.sh ${_project_name} ${_project_version} ${port}"
                       }
                   }
                 }
             }
    }
}