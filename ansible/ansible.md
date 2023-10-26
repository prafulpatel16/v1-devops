# Setup Ansible
1. Install ansibe on Ubuntu 22.04 
   ```sh 
   sudo apt update
   sudo apt install software-properties-common
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible
   ```
![Alt text](image-2.png)
   
![Alt text](image-3.png)

![Alt text](image-6.png)


2. Add Jenkins master and slave as hosts 
Add jenkins master and slave private IPs in the inventory file 
in this case, we are using /opt is our working directory for Ansible. 
   ```
    [jenkins-master]
    18.209.18.194
    [jenkins-master:vars]
    ansible_user=ec2-user
    ansible_ssh_private_key_file=/opt/dpo.pem
    [jenkins-slave]
    54.224.107.148
    [jenkins-slave:vars]
    ansible_user=ec2-user
    ansible_ssh_private_key_file=/opt/dpo.pem
   ```
![Alt text](image-4.png)

It needs to add jenkins master and jenkins slave machines as managed nodes into Ansible control
![Alt text](image-5.png)

Need to copy the Private IP of those systems because public ip get changing when system restarts.

Create hosts file in ansible control

$vi hosts

![Alt text](image-7.png)

Need to create a group of hosts
[jenkins-master]
10.1.1.122
![Alt text](image-8.png)
![Alt text](image-9.png)

Create jenkins-master variables for ansible to login
![Alt text](image-10.png)

user - ubuntu
password: is a key file 

![Alt text](image-11.png)

Successfully added
![Alt text](image-12.png)

Test the connection

Copy the .pem file from windows to /opt folder in ansible server

![Alt text](image-13.png)

Change permission to key file
![Alt text](image-14.png)

Test the connection to jenkins master from ansible control

ansible all -i hosts -m ping

Connection successfull

![Alt text](image-15.png)

Add Jenkins-slave to ansible control

[jenkins-slave]
10.1.1.98

copy private ip of jenkins -slave
![Alt text](image-16.png)

![Alt text](image-18.png)

Test the connection with jenkins-slave from ansible control

![Alt text](image-19.png)


1. Test the connection  
   ```sh
   ansible -i hosts all -m ping 
   ```

Write ansible playbook to install jenkins

---
- hosts: jenkins-master
  become: true
  tasks:
  - name: add jenkins key
    apt_key:
      url: https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
      state: present

  - name: add jenkins repo 
    apt_repository: 
      repo: 'deb https://pkg.jenkins.io/debian-stable binary/'
      state: present 

  - name: install java 
    apt: 
      name: openjdk-11-jre
      state: present

  - name: install jenkins 
    apt: 
      name: jenkins 
      state: present       

  - name: start jenkins service 
    service: 
      name: jenkins 
      state: started 

  - name: enable jenkins to start at boot time 
    service: 
      name: jenkins 
      enabled: yes 

Login to Jenkins-master
![Alt text](image-8.png)

jenkins is not yet installed
![Alt text](image-16.png)

Copy Ansible playbook to Ansible control

![Alt text](image-20.png)

Let's dry run 
![Alt text](image-21.png)

![Alt text](image-22.png)

LEt's run playbook to install jenkins

![Alt text](image-23.png)

Ansible playbook ran successully and installed all packages for jenkins
![Alt text](image-24.png)

Verify that jenkins is running

![Alt text](image-25.png)

Access jenkins from browser UI

<public ip>:8080

![Alt text](image-26.png)


Configure jenkins server

![Alt text](image-27.png)

![Alt text](image-28.png)

![Alt text](image-29.png)

![Alt text](image-30.png)

![Alt text](image-31.png)

Jenkins accessed successfully
![Alt text](image-32.png)


Write a playbook to set up jenkins-slave

![Alt text](image-33.png)

Execute playbook to setup jenkins-slave

Login to jenkins-salve to chekc if maven file is present

![Alt text](image-34.png)

Go to Ansible control and run playbook

Check it first
![Alt text](image-35.png)

![Alt text](image-36.png)

apache-maven installed successfully
![Alt text](image-37.png)

apache maven uploaded to jenkin-slave
![Alt text](image.png)

![Alt text](image-1.png)



























































