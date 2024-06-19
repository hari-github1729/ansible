#
#
#   This script is created to automate the web server deployment using ansible
#   Author:Harish S
#   contact:->hari2779ka@gmail.com
echo -e "\e[32m +Installing required packages\e[0m"
echo 
apt install figlet lolcat
echo 

echo -e "\e[32m +Installing ansible\e[0m"
echo
apt install ansible
echo 

figlet -f slant The Deployer | lolcat

figlet -f digital -c Deployment Made Easy | lolcat

echo -e "\e[32m +ENTER THE TARGET SERVER'S IP ADDRERSS:\e[0m"

read target
echo 

echo -e "\e[32m +ENTER THE TARGET SERVER'S USER NAME:\e[0m"

read name
echo 

echo -e "\e[32m +SETTING UP PASSWORDLESS AUTHENTICATION:\e[0m"
ssh-copy-id $name@$target

cat <<EOL >inv
[webservers]
$target ansible_user=$name
EOL
echo
echo -e "\e[32m +ANSIBLE SCRIPTING IN PROGRESS:\e[0m"
echo
cat <<EOL >main.yml
---
- name: main
  hosts: all
  become: yes

  tasks:
   - name: update apt
     apt:
      update_cache: yes

   - name: install nginx
     apt:
      name: nginx
      state: present

   - name: copy html content
     copy:
      src: index.html
      dest: /var/www/html
      
   - name: start the nginx server
     service:
      name: nginx
      state: started
EOL

echo
echo -e "\e[32m +DEPLOYMENT BEGINS:\e[0m"
echo

ansible-playbook -i inv main.yml

echo
echo http://$target
echo

figlet -f slant THANK YOU! | lolcat
