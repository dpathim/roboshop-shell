log=/tmp/roboshop.log
func_apppreq() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create ${component} Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Cleanup Existing Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
      rm -rf / app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    mkdir /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app
}
func_systemd() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Start ${component} Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
}
func_nodejs() {

 func_apppreq
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mongodb Repo<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
   cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install nodejs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y  &>>${log}
  dnf module enable nodejs:18 -y  &>>${log}
  dnf install nodejs -y  &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mongodb Client<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Load ${component} Schema<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mongo --host mondodb.vdevops562.online </app/schema/${component}.js &>>${log}

 }

func_java() {

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Build ${component} Service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

 echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install mysql Client<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Load Schema<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mysql -h mysql.vdevops562.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

 func_systemd
}

func_python() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Build ${component} service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Build ${component} service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}

  func_systemd
}
func_golang() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install golang <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install golang -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Build ${component}service<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
   func_systemd
}