# Assessment - Andreas Siailis
All of the mentioned scripts can be found under /scripts directory of this repository

Helm Charts can be found in this repository: https://github.com/shaeliss/assessment-argoCD

## Jenkins instance
Decided to spin up my Jenkins instance by using EC2 AWS instances because this way i was able to add a worker node on my Jenkins instance which is a better practise that running Pipelines on Master Node. I installed terraform on my local pc and wrote a small script (main.tf) to create two EC2 istances along with their security group allowing inbound tcp on 8080 port where Jenkins is exposed. The AWS implementation along with the Terraform script allowed me to easily keep track of the created resources on AWS and also delete them easily once i dont need them to avoid extra costs.

On the master node:
- Installed java and Jenkins by following the official documentation
- Also install git to allow my Jenkins Pipeline to checkout the Jenkinsfile from my github repo
- Created an ssh certificate to allow my worker node to connect to my master node

On the worker node:
- Installed docker and git 
- Get public key which was created on Jenkins master (id_rsa.pub) and place it in ~/.ssh/authorized_keys of jenkins user (sudo su - jenkins
- Also made sure that /home/jenkins has jenkins:jenkins owner
  - If needed to sudo chown jenkins:jenkins on /home/jenkins)

## Kubernetes Cluster
Decided to provision my cluster using minikube on my local machine as the needs for resources and complexity is low for the purpose of the assessment. A single node cluster should be enough for the single pod (per namespace) in the cluster. 





