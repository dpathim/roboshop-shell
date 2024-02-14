Mysql_root_password=$1
  if [ -z "${Mysql_root_password}" ]; then
    echo INpute Missing Password
    exit
    fi

cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf module disable mysql -y

dnf install mysql-community-server -y


systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass ${Mysql_root_password}

#RoboShop@1