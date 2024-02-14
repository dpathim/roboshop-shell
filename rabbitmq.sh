component=rabbitmq
source common.sh

rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
echo Inpute RabbitMQ AppUser password Missing
exit 1
fi


echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install rabbitmq server<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}

dnf install rabbitmq-server -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Install rabbitmq server<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server &>>${log}
systemctl start rabbitmq-server &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>create rabbitmq user and password <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_app_password} &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Set  rabbitmq Permission<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
func_exit_status



#roboshop123