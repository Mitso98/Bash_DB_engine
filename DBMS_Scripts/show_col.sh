#!/bin/bash

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

if [ -z $current_db ]
then
    echo '+---------------------------------+'
	echo "You are not connected to DB"
    echo '+---------------------------------+'
	exit 1
fi

# get table name
echo '+---------------------------------+'
echo "Enter table name"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]
do
    echo "Enter table name"
    read -r table_name
done
echo '+---------------------------------+'

echo '+----------------------------------------------------------------+'
awk -F'|' 'NR==2{print}' "$DB_PATH/$current_db/$table_name"
echo '+----------------------------------------------------------------+'
exit 0
