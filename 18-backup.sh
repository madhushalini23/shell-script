#!/bin/bash

R="\e[31m"]
G="\e[32m"]
Y="\e[33m"]
N="\e[0m"]

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

LOGS_FOLDER="/home/ec2-user/shellscript-logs"
LOG_FILE=$(echo $0 | awk -F "/" '{print $NF}' | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2... $R failure $N"
        exit 1
    else
        echo -e "$2... $G success $N"
    fi
}

USAGE(){
    echo -e "$R USAGE:: $N sh 18-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS(OPTIONAL)>"
    exit 1
}

mkdir -p /home/ec2-user/shellscript-logs/

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]
then
    echo -e "$SOURCE_DIR does not exist...please check"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo -e "$DEST_DIR does not exist...please check"
    exit 1
fi

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

echo "files are: $FILES"

if [ -n "$FILES" ]
then
    echo "files are: $FILES"
    ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE"
    if [ -f "$ZIP_FILE" ]
    then  
        echo -e "succesfully created file for files older than $DAYS"
        while read -r filepath
        do
            echo "deleting file: $filepath" &>>$LOG_FILE_NAME
            rm -rf $filepath
            echo "deleted file: $filepath"
        done <<< "$FILES_TO_DELETE"
    else
        echo -e "$R error:: $N failed to create ZIP file"
        exit 1
    fi

else 
    echo "no files found older than $DAYS"
fi
