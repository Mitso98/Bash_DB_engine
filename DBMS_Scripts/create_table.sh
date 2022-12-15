#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare tbale_name
current_db=`cat "$DB_PATH/current_db"`

if [ -z $current_db ]
then
	echo "You are not connected to DB"
	exit 1
fi

if [ $# -eq 0 ]
then
	echo "Enter table name"
	read -r table_name
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]
then 
	echo "PLease enter a valid name"
	exit 1
fi

list_tables=`ls -d $DB_PATH/$current_db/* | cut -f4 -d '/' `

for tables in $list_tables
do	
	if [ $tables = $table_name ]
	then
		echo "This table already exists"
		exit 1
	fi
done

touch  "$DB_PATH/$current_db/$table_name"


