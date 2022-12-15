#!/usr/bin/bash

source ./db_root_path.sh

if [ ! -z "$DB_PATH/current_db" ]
then 
curr=`cat $DB_PATH/current_db`
echo "" > $DB_PATH/current_db
echo "you are Disconnected from $curr"

else 

echo "you are not connected to any Databases"

fi
