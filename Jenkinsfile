pipeline {
     agent any
     tools{
       maven "M3"
     }
    environment {
        _project_name = "rachael-zuul"
        _project_version = "1.0"
        _git_address = "https://github.com/NoodleCookie/Rachael-zuul.git"
        _harbor_address = "8.140.110.215:85"
        _harbor_project_name = "rachael"
        _credentialsId = "24d1ea7f-7c07-4eea-9f84-9a6298334aea"
    }

    stages {
             stage('Pull Code') {
                 steps{
                     sh "rm -rf ${env.WORKSPACE}/project"
                     sh "mkdir ${env.WORKSPACE}/project"
                     dir("${env.WORKSPACE}/project") {
                         git "${_git_address}"
                         }
                    }
                 }

             stage('Compile'){
                     steps{
                         script{
                             dir("${env.WORKSPACE}/project"){
                                 sh "mvn clean compile"
                             }
                         }
                     }
                 }

            stage("Build Jar") {
                        steps {
                            script {
                                dir("${env.WORKSPACE}/project") {
                                    sh "mvn clean package"
                                }
                            }
                        }
                    }

            stage("Build Image and Publish") {
                 steps {
                     script {
                         dir("${env.WORKSPACE}/project") {
                             sh "docker build -t ${_project_name}:${_project_version} ."
                             sh "docker tag ${_project_name}:${_project_version} ${_harbor_address}/${_harbor_project_name}/${_project_name}:${_project_version}"
                         }
                     }

                     script {
                        withCredentials([usernamePassword(credentialsId: "${_credentialsId}", passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            sh "docker login -u ${USERNAME} -p ${PASSWORD} ${_harbor_address}"
                            sh "docker push ${_harbor_address}/${_harbor_project_name}/${_project_name}:${_project_version}"
                        }

                       // 远程部署
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'Aliyun_server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: "/opt/jenkins_shell/deploy.sh ${_harbor_address} ${_harbor_project_name} ${_project_name} ${_project_version} ${port}", execTimeout: 0, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '', usePty: true)], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                     }
                 }
             }
    }
}