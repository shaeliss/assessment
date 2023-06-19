def buildNumber = env.BUILD_NUMBER
try{
    node('docker'){
        stage('Checkout') {
            STAGE='Checkout'
            checkout([$class: 'GitSCM',
              branches: [[name: '*/main']], // Specify the branch to checkout
              userRemoteConfigs: [[
                url: 'https://github.com/shaeliss/assessment.git'
              ]]
            ])
        }
        
        stage('Build Docker image'){
            STAGE='Build Docker image'
            withCredentials([usernamePassword(credentialsId: 'dockerhub_as', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh"""
                    docker build -t andresia/assessment:${buildNumber} .
                    docker images
                """
            }   
        }
        
        stage('Push Docker image'){
            STAGE='Push Docker image'
            withCredentials([usernamePassword(credentialsId: 'dockerhub_as', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh"""
                    docker login -u $USERNAME -p $PASSWORD
                    docker push andresia/assessment:${buildNumber}
                    
                """
            }   
        }
        
        
        stage('Deploy on staging'){
            STAGE='Deploy on staging'
            if (!params.SkipDeployment){
                withCredentials([string(credentialsId: 'jenkins-git-token', variable: 'TOKEN')]){
                    sh"""
                        rm -rf assessment-argoCD || true
                        git config --global user.name 'shaeliss'
                        git config --global user.email 'andreas.shaelis@hotmail.com'
                        git clone https://${TOKEN}@github.com/shaeliss/assessment-argoCD.git -b staging
                        VALUESPATH='assessment-argoCD/mychart/values.yaml'
                        sed -i 's#image.*#image: andresia/assessment:${buildNumber}#g' \$VALUESPATH 
                        cat \$VALUESPATH
                        cd assessment-argoCD
                        git add .
                        git commit -m "Jenkins deployment"
                        git push origin HEAD:staging
                        cd ..
                    """
                }
            } else {
                println('Deployment was skipped using Parameter')
            }
        }
        
    }
} catch (Exception e1){
    currentBuild.result = "FAILURE"
    currentBuild.setResult=("FAILURE")
    echo e1.getMessage()
    errorMSG = e1.toString()
}

