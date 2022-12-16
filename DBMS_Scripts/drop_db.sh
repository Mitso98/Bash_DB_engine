#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare DB

typeset curr=`cat $DB_PATH/current_db`

if [ $# -eq 0 ]
then 
	echo "Enter DB Name to Drop : "
	read -r DB
fi

if [ -d "$DB_PATH/$DB" ]
    then 	

    if [ "$DB" = "$curr" ]

    then 
        echo "Your now connected to $DB please exit from $DB first"

    else 
                rm -r "$DB_PATH/$DB"
                echo "The $DB Data Base Droped Successfuly"
    
        exit 0
    fi



    else
            echo "PLease enter a valid DB name"
            exit 1 
    fi
