#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare DB

#show existed DB to help the user
source ./show_db.sh

if [ $# -eq 0 ]; then
	echo '+---------------------------------+'
	echo -e "Enter DB name : \c"
	echo '+---------------------------------+'
	read -r DB
fi

if [ -d "$DB_PATH/$DB" ]; then
	echo '+---------------------------------+'
	echo "$DB" >$DB_PATH/current_db
	echo "DB $DB is connected"
	echo '+---------------------------------+'
	exit 0
else
	echo '+---------------------------------+'
	echo "PLease enter a valid DB name"
	echo '+---------------------------------+'
	exit 1
fi
