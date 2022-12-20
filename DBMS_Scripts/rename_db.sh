#!/usr/bin/bash

source ./db_root_path.sh

declare DB
declare NEWDB
typeset curr=$(cat $DB_PATH/current_db)

if [ $# -eq 0 ]; then
    echo '+---------------------------------+'
    echo -e "Enter DB name : \c"
    read -r DB
    echo '+---------------------------------+'
fi

if [ -d "$DB_PATH/$DB" ]; then

    if [ "$DB" = "$curr" ]; then
        echo '+-------------------------------------------------------+'
        echo "Your now connected to $DB please exit from $DB first"
        echo '+-------------------------------------------------------+'

    else
        echo '+-------------------------------------------------------------+'
        echo -e "Enter the new name of DB : \c"
        read -r NEWDB

        mv "$DB_PATH/$DB" "$DB_PATH/$NEWDB"
        echo "The $DB Data Base Renamed to $NEWDB Successfuly"
        echo '+--------------------------------------------------------------+'

    fi

    exit 0

else
    echo '+---------------------------------+'
    echo "PLease enter a valid DB name"
    echo '+---------------------------------+'
    exit 1
fi
