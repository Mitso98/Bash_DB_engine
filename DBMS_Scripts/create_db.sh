#!/bin/bash
# Create data base

# IMPORT DB_PATH variable
source ./db_root_path.sh


declare DB

#check whether root folder exist
if [ ! -d $DB_PATH ]
then
	mkdir $DB_PATH
fi 

# user entered DB name
if [ $# -eq 0 ]
then
	echo "Enter DB name" 
	read  -r DB
fi
	
if [ -d "$DB_PATH/$DB" ]
then
	echo "DB already exists"
	exit 1
elif [[ $DB =~ ^[A-Za-z].* ]]
then	
	mkdir "$DB_PATH/$DB"
	echo "$DB is Created Successfully"
	exit 0
else
	echo "Please enter a valid input!"
fi
	


