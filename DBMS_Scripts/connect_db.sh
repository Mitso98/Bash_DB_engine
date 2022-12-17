#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare DB

#show existed DB to help the user
source ./show_db.sh

if [ $# -eq 0 ]
then 
	echo -e "Enter DB name : \c"
	read -r DB
fi


if [ -d "$DB_PATH/$DB" ]
then 	
	echo "$DB" > $DB_PATH/current_db
	echo "DB $DB is connected"
	exit 0
else
	echo "PLease enter a valid DB name"
	exit 1 
fi

