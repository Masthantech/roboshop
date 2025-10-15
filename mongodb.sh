#!/bin bash

USERID=$(id -u)
R="\e[31m"
g="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
mkdir -p $LOG_FOLDER

CHECK_ROOT () {
    if [ $USERID -ne 0 ] 
    then 
        echo -e " $R ERROR...Please run this script with root access $N"
        exit 1
    else 
        echo -e " $Y You are running the script wit root access $N"    
    fi     
}

VALIDATE () {
    if [ $1 -ne 0 ]
    then 
        echo -e  "$2 is.... $R ERROR $N"
        exit 1
    else 
        echo -e   "$2 is....$G SUCCESS $N"    
    fi    
}

echo  "Script started running at: $(date)"
CHECK_ROOT 

cp /$SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo repo"

dnf install mongodb-org -y 
VALIDATE $? "Installing MongoDB"

systemctl enable mongod 
systemctl start mongod  
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing  mongod conf file to allow remote connections"

systemctl restart mongod
VALIDATE $? "Restarting MongoDB"


