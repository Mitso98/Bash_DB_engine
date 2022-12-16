#!/bin/bash

## in progress we may use awk to write at nth line
# IMPORT DB_PATH variable
source ./db_root_path.sh

declare col_name
declare col_type
declare is_pk
while true
do
    echo "Enter column name"
    read -r col_name

    echo "Enter column type: str or int"
    read -r col_type

    echo "Enter 'y' if you want this column as PK."
    read -r is_pk

	if [[ $col_name =~ ^[A-Za-z0-9].* ]] && [[ $col_type = "str" ]] && [[ $is_pk = "y" ]]
	then	
		sed -i "1i\" Makefile.txt

        echo -n "$col_name," >> "$DB_PATH/$current_db/$table_name"
	else
		echo "Column names can only start with alphabet or numbers"
	fi

    echo "Do you want to continue?"
    read -r cont

    if [[ "$cont" != "y" ]] && [[ "$cont" != "yes" ]]
    then
        break
    fi
done