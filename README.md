# Assessment - Andreas Siailis
All of the mentioned scripts can be found under /scripts directory of this repository

Helm Charts can be found in this repository: https://github.com/shaeliss/assessment-argoCD

## Jenkins instance 
Official documentation - - https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/

Decided to spin up my Jenkins instance by using EC2 AWS instances because this way i was able to add a worker node on my Jenkins instance which is a better practise that running Pipelines on Master Node. I installed terraform on my local pc and wrote a small script (main.tf) to create two EC2 istances along with their security group allowing inbound tcp on 8080 port where Jenkins is exposed. The AWS implementation along with the Terraform script allowed me to easily keep track of the created resources on AWS and also delete them easily once i dont need them to avoid extra costs.

### On the master node:
- Installed java and Jenkins by following the official documentation
- Also install git to allow my Jenkins Pipeline to checkout the Jenkinsfile from my github repo
- Created an ssh certificate to allow my worker node to connect to my master node

### On the worker node:
- Installed docker and git 
- Get public key which was created on Jenkins master (id_rsa.pub) and place it in ~/.ssh/authorized_keys of jenkins user (sudo su - jenkins
- Also made sure that /home/jenkins has jenkins:jenkins owner
  - If needed to sudo chown jenkins:jenkins on /home/jenkins)

### On the istance

- I created credentials for my git and dockerhub accounts so that they are not exposed in the Pipeline
- I connected the Worker Node on the Master to run my builds on it
- I created a CB Pipeline to Automate the containerization of the application (Jenkinsfile in repo)
- I created a webhook on my github repository and also configure my Pipeline so that it will be triggered each time there is a commit in it. This way the developers can test their changes by using the new image on the dev Cluster with almost zero effort


## Kubernetes Cluster

### Spinning up the cluster - https://minikube.sigs.k8s.io/docs/start/
Decided to provision my cluster using minikube on my local machine as the needs for resources and complexity is low for the purpose of the assessment. A single node cluster should be enough for the single pod (per namespace) in the cluster. I also deployed argoCD in my cluster using the official documentation and used port forwarding to expose the UI locally and monitor my deployments. 


### RBAC Authorization
To achieve the needed restrictions per group of users (devs,devops,qa), i applied RBAC on my cluster by creating a role and rolebinding in each namespace to eachive the restrictions in the description of the assessment. The helm charts for these roles and rolebindings can be found in the repository provided at the top of the file. I also created a kube config file for each of the group of users so that it will be provided to them depending on the needed level of access on the Cluster. This will be applied when connecting to the cluster machine using export KUBECONFIG=config-file

## Details of deployment

- Used a liveness probe on the application pod in order to be able to understand when the pod is ready to serve requests
- Added a different user in the Dockerfile to avoid using root and introducing security vulnerabilities

## Potential improvements

1. Consider using a canary deployment on the Cluster to be able to test changes on the application on an initially smaller user base by using a load balancer
2. Consider using an autoscalling cluster which will be able to introduced new worker nodes in case of increased traffic
   - Can use AWS Spot instances for this and also carpenter
3. Buy an SSL certificate from a reputable provider and also a DOMAIN NAME to use for exposing the application online
4. Add Pipeline which will be responsible for scanning the source code for security vulnerabilities






