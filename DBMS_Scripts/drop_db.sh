#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare DB

typeset curr=$(cat $DB_PATH/current_db)

if [ -z $current_db ]; then
    echo '+---------------------------------+'
    echo "You are not connected to DB"
    echo '+---------------------------------+'
    exit 1
fi

echo '+---------------------------------+'
echo "Enter DB Name to Drop : "
read -r DB
echo '+---------------------------------+'

if [ -d "$DB_PATH/$DB" ]; then
    if [ "$DB" = "$curr" ]; then
        echo "Your now connected to $DB please exit from $DB first"

    else
        rm -r "$DB_PATH/$DB"
        echo '+-------------------------------------+'
        echo "The $DB Data Base Droped Successfuly"
        echo '+--------------------------------------+'

        exit 0
    fi
else
    echo '+---------------------------------+'
    echo "PLease enter a valid DB name"
    echo '+---------------------------------+'
    exit 1
fi
