#!/bin/bash
# Create data base

#source ./db_root_exist.sh

#check whether root folder exist
if [ ! -d db_root ]
then
	mkdir db_root
fi 

# user entered DB name
if [ $# -eq 1 ]
then 
	mkdir db_root/"$1"
	exit 0
elif [ $# -eq 0 ]
then
	echo "Enter DB name"
	read DB	
	
	if [ -d db_root/$DB ]
	then
		echo "DB already exists"
		exit 1
	elif [[ $DB =~ ^[A-Za-z].* ]]
	then	
		mkdir db_root/"$DB"
		exit 0
	else
		echo "Please enter a valid input!"
	fi
	
else
	echo "Please enter a valid input"
	exit 1
fi

