node {
    stage('SCM Checkout'){
        checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'PerBuildTag']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/Manoj-Reddy-Aleti/dragonfly.git']]])

    }
    
    stage('MVN Package'){
        def mvnHOME = tool name: 'maven-3.6.3', type: 'maven'
        def mvnCMD = "${mvnHOME}/bin/mvn"
        sh "${mvnCMD} clean package"
    }
    
    stage('Build Docker Image'){
        sh 'docker build -t manojreddyaleti/my-testing-app:${BUILD_NUMBER} .'
    }
    
    stage('Push Docker Image'){
       
        withCredentials([string(credentialsId: 'DockerHubPassword', variable: 'DockerHubPassword')]) {
            sh "docker login docker.io -u manojreddyaleti -p ${DockerHubPassword}"
            sh 'docker push manojreddyaleti/my-testing-app:${BUILD_NUMBER}'
        }
    }

    stage('Run Container in K8s'){

        sh "chmod +x changeTag.sh"
        sh "./changeTag.sh"

        sshagent(['GCP-EKS-AWS']) {
            sh "scp -o StrictHostKeyChecking=no DragonflyLB.yaml Dragonfly_pods.yaml tkma2w6@35.224.131.12:/home/tkma2w6/"

            script{
                try{
                    withCredentials([string(credentialsId: 'DockerHubPassword', variable: 'DockerHub')]) {
                        sh "ssh -o StrictHostKeyChecking=no tkma2w6@35.224.131.12 kubectl create secret docker-registry dragonflyapp --docker-server=https://index.docker.io/v1/ \
                        --docker-username=manojreddyaleti --docker-password=${DockerHub} --docker-email=amanojreddy18@gmail.com"
                    }
                }catch(error){
                    sh "echo Secret already exists"
                }

            }

            script{
                try{
                    sh "ssh -o StrictHostKeyChecking=no tkma2w6@35.224.131.12 kubectl apply -f ."
                }catch(error){
                    sh "ssh -o StrictHostKeyChecking=no tkma2w6@35.224.131.12 kubectl create -f ."
                }
            }

        }
    }

    
}
