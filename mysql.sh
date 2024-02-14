source common.sh
Mysql_root_password=$1
  if [ -z "${Mysql_root_password}" ]; then
    echo INpute Missing Password
    exit
    fi
echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mysql Repo<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>{log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mysql<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y &>>{log}
dnf install mysql-community-server -y &>>{log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Start Mysql service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld &>>{log}
systemctl start mysqld &>>{log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Mysql Password Inpute<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${Mysql_root_password}
func_exit_status

#RoboShop@1