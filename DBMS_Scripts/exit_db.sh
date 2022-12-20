#!/usr/bin/bash

source ./db_root_path.sh

if [ ! -z "$DB_PATH/current_db" ]; then
    curr=$(cat $DB_PATH/current_db)
    echo "" >"$DB_PATH/current_db"
    echo '+--------------------------------------------+'
    echo "you are Disconnected from $curr"
    echo '+--------------------------------------------+'

else
    echo '+----------------------------------------------------+'
    echo "you are not connected to any Databases"
    echo '+----------------------------------------------------+'

fi
