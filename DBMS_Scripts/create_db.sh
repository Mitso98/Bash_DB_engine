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
	echo '+------------------------------------+'
	echo -e "Enter DB name : \c" 
	read  -r DB
	echo '+------------------------------------+'
fi
	
if [ -d "$DB_PATH/$DB" ]
then
	echo '+------------------------------------+'
	echo "DB already exists"
	echo '+------------------------------------+'
	exit 1
elif [[ $DB =~ ^[A-Za-z].* ]]
then	
	mkdir "$DB_PATH/$DB"
	echo '+------------------------------------+'
	echo "$DB is Created Successfully"
	echo '+------------------------------------+'
	exit 0
else
	echo '+------------------------------------+'
	echo "Please enter a valid input!"
	echo '+------------------------------------+'
fi
	


