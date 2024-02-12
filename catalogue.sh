echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Catalogue Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mongodb Repo<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install nodejs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application user e<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mongodb Client<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Load Catalogue Schema<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mondodb.vdevops562.online </app/schema/catalogue.js

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Start Catalogue Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue