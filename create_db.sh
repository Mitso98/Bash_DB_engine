#!/bin/bash
# Create data base

#check whether root folder exist
source ./db_root_exist.sh

# user entered DB name
if [ $# -eq 1 ]
then 
	mkdir db_root/"$1"
	exit 0
elif [ $# -eq 0 ]
then
	echo "Enter DB name"
	read DB	

	if [[ $DB =~ ^[A-Za-z].* ]]
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

