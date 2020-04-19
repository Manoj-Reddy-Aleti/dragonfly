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
        sh 'docker build -t manojreddyaleti/my-testing-app:${BUILD_NUMBER}.'
    }
    
    stage('Push Docker Image'){
       
    withCredentials([string(credentialsId: 'DockerHubPassword', variable: 'DockerHubPassword')]) {
    sh "docker login docker.io -u manojreddyaleti -p ${DockerHubPassword}"
    }

    sh 'docker push manojreddyaleti/my-testing-app:${BUILD_NUMBER}'
    }
    
}
