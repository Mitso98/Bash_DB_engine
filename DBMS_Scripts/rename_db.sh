#!/usr/bin/bash

source ./db_root_path.sh

declare DB 
declare NEWDB
typeset curr=`cat $DB_PATH/current_db`


if [ $# -eq 0 ]
then 
	echo "Enter DB name"
	read -r DB
    fi


if [ -d "$DB_PATH/$DB" ]
    then


    if [ "$DB" = "$curr" ]

    then 
        echo "Your now connected to $DB please exit from $DB first"

    else 

        echo "Enter the new name of DB :"
	    read -r NEWDB 	

                mv "$DB_PATH/$DB" "$DB_PATH/$NEWDB"
                echo "The $DB Data Base Renamed to $NEWDB Successfuly"
    
        
    fi

    exit 0

    else
            echo "PLease enter a valid DB name"
            exit 1 
    fi
