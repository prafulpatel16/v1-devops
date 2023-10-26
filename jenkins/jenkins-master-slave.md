# Jenkins Master and Slave Setup

1. Add credentials 
2. Add node
   
### Add Credentials 
1. Manage Jenkins --> Manage Credentials --> System --> Global credentials --> Add credentials
2. Provide the below info to add credentials   
   kind: `ssh username with private key`  
   Scope: `Global`     
   ID: `maven_slave`    
   Username: `ec2-user`  
   private key: `devops-key.pem key content`  

![Alt text](image.png)

![Alt text](image-1.png)


View initial Jenkins password:
cat /var/lib/jenkins/secrets/initialAdminPassword


### Add node 
   Follow the below setups to add a new slave node to the jenkins 
1. Goto Manage Jenkins --> Manage nodes and clouds --> New node --> Permanent Agent    
2. Provide the below info to add the node   
   Number of executors: `3`   
   Remote root directory: `/home/ec2-user/jenkins`  
   Labels: `maven`  
   Usage: `Use this node as much as possible`  
   Launch method: `Launch agents via SSH`  
        Host: `<Private_IP_of_Slave>`  
        Credentials: `<Jenkins_Slave_Credentials>`     
        Host Key Verification Strategy: `Non verifying Verification Strategy`     
   Availability: `Keep this agent online as much as possible`  

Manage jenkins-master slave configuration

Add node

![Alt text](image-2.png)

![Alt text](image-3.png)

![Alt text](image-4.png)

![Alt text](image-5.png)

![Alt text](image-6.png)

Agent is online
![Alt text](image-7.png)

Verify from the jenkins-slave that remote jenkins file automatically copied to slave

/home/ubuntu/

![Alt text](image-8.png)

Let's verify and test pipeline to check it's run on slave server

Create a test job on freestyle prpject

![Alt text](image-9.png)

![Alt text](image-10.png)

![Alt text](image-11.png)

Build the job

Build success
![Alt text](image-12.png)

Verify in the location to slave server
![Alt text](image-13.png)

/home/ubuntu/jenkins/workspace/test-job

![Alt text](image-14.png)

Let's write a jenkins pipeline

![Alt text](image-15.png)

![Alt text](image-17.png)

![Alt text](image-18.png)

![Alt text](image-19.png)

![Alt text](image-20.png)

![Alt text](image-21.png)

![Alt text](image-22.png)

![Alt text](image-23.png)


# Create Jenkinsfile into sourcecode web app
![Alt text](image.png)
pipeline {
    agent {
        node {
            label 'maven-slave'
        }
    }

    stages {
        stage('clone-code') {
            steps {
                git branch: 'main', url: 'https://github.com/prafulpatel16/t1-ttrend.git'
            }
        }
    }
}

push file to remote sourcecod repo
![Alt text](image-1.png)

Generate a new token in GitHUB
![Alt text](image-2.png)

Token generated:
![Alt text](image-3.png)


# Adding a GitHUB token to JENKINS

Go to Manage Jenkins > Credentials > System > Global Crednetials
Add Credentials


![Alt text](image-4.png)

![Alt text](image-5.png)

![Alt text](image-6.png)

![Alt text](image-7.png)

Go to Pipeline "ttrend-job" > Configure > Credentials

# Create Pipeline script from SCM

![Alt text](image-8.png)

![Alt text](image-9.png)

![Alt text](image-10.png)

# CReate multibranch pipeline

![Alt text](image-11.png)

![Alt text](image-12.png)

![Alt text](image-13.png)

![Alt text](image-14.png)

Create a new brnach "dev"
![Alt text](image-15.png)

![Alt text](image-16.png)

# Create a new branches
Create a 'dev' brnach with same code
Creae a 'stag' branch and remove jenkinsfile from the source code of that branch
![Alt text](image-17.png)
![Alt text](image-18.png)
![Alt text](image-19.png)
![Alt text](image-20.png)

# Copy JEnkinsfile to 'stag' branch
![Alt text](image-21.png)

Push jenkinsfile to remote stag branch
![Alt text](image-22.png)


# Verify in Jenkins dashboard that all 3 brnaches as scanned and displayed there

![Alt text](image-23.png)
![Alt text](image-24.png)

# Setup GitHub Webhook

# Enable Webhook
1. Install "multibranch scan webhook trigger" plugin  
    From dashboard --> manage jenkins --> manage plugins --> Available Plugins  
    Search for "Multibranch Scan webhook Trigger" plugin and install it. 

![Alt text](image-25.png)


2. Go to multibranch pipeline job
     job --> configure --> Scan Multibranch Pipeline Triggers --> Scan Multibranch Pipeline Triggers  --> Scan by webhook   
     Trigger token: `<token_name>`

![Alt text](image-26.png)
JENKINS_URL/multibranch-webhook-trigger/invoke?token=[Trigger token] 
http://3.239.237.56:8080/multibranch-webhook-trigger/invoke?token=devops-token




3. Add webhook to GitHub repository
   Github repo --> settings --> webhooks --> Add webhook  
   Payload URl: `<jenkins_IP>:8080/multibranch-webhook-trigger/invoke?token=<token_name>`  
   Content type: `application/json`  
   Which event would you like to trigger this webhook: `just the push event` 

Once it is enabled make changes to source to trigger the build. 

![Alt text](image-27.png)

http://3.239.237.56:8080/multibranch-webhook-trigger/invoke?token=devops-token

![Alt text](image-28.png)

![Alt text](image-29.png)

Commit changes to master branch and see the pipline is trigers from webhook itself

Master pipeline triggered

Commited changes triggered through webhook to jenkins master branch
![Alt text](image-30.png)
































































































