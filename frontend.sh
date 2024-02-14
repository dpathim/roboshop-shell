
source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>install Nginx <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Copy RoboShop Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/robosop.conf
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Clean Old Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Downloading Application Content <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_exit_status

cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Start Nginx Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx
func_exit_status