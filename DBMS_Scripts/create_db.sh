#!/bin/bash
# Create data base

# IMPORT DB_PATH variable
source ./db_root_path.sh

#check whether root folder exist
if [ ! -d $DB_PATH ]
then
	mkdir $DB_PATH
fi 

# user entered DB name
if [ $# -eq 1 ]
then 
	mkdir $DB_PATH/"$1"
	exit 0
elif [ $# -eq 0 ]
then
	echo "Enter DB name"
	read DB	
	
	if [ -d $DB_PATH/$DB ]
	then
		echo "DB already exists"
		exit 1
	elif [[ $DB =~ ^[A-Za-z].* ]]
	then	
		mkdir $DB_PATH/$DB
		exit 0
	else
		echo "Please enter a valid input!"
	fi
	
else
	echo "Please enter a valid input"
	exit 1
fi

