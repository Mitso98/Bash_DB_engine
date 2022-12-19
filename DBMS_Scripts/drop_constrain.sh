#!/bin/bash

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

if [ -z $current_db ]
then
	echo "You are not connected to DB"
	exit 1
fi


