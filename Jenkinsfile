def buildNumber = env.BUILD_NUMBER

node('docker'){
    stage('Checkout') {
        checkout([$class: 'GitSCM',
          branches: [[name: '*/main']], // Specify the branch to checkout
          userRemoteConfigs: [[
            url: 'https://github.com/shaeliss/assessment.git'
          ]]
        ])
    }
    
    stage('Build Docker image'){
        withCredentials([usernamePassword(credentialsId: 'dockerhub_as', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh"""
                docker build -t andresia/assessment:${buildNumber} .
                docker images
            """
        }   
    }
    
    stage('Push Docker image'){
        withCredentials([usernamePassword(credentialsId: 'dockerhub_as', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh"""
                docker login -u $USERNAME -p $PASSWORD
                docker push andresia/assessment:${buildNumber}
                
            """
        }   
    }
    
}
