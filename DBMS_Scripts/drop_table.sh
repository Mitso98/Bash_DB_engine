#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare tbale_name
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then
	echo '+---------------------------------+'
	echo "You are not connected to DB"
	echo '+---------------------------------+'
	exit 1
fi

if [ $# -eq 0 ]; then
	echo '+---------------------------------+'
	echo -e "Enter table name: \c"
	read -r table_name
	echo '+---------------------------------+'
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]; then
	echo '+---------------------------------+'
	echo "PLease enter a valid name"
	exit 1
	echo '+---------------------------------+'
fi

# TODO create if [ -f table] rather than loop
list_tables=$(ls -d $DB_PATH/$current_db/* | cut -f4 -d '/')
echo '+----------------------------------------------------+'
for tables in $list_tables; do
	if [ $tables = $table_name ]; then
		echo "$table_name has been deleted"
		$(rm "$DB_PATH/$current_db/$table_name")
		exit 0
	fi
done
echo '+---------------------------------+'
echo "Table was not found"
echo '+---------------------------------+'
exit 1
