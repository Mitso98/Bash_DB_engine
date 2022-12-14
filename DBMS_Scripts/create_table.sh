#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare tbale_name

if [ $# -eq 0 ]
then
	read table_name
else
	$table_name=$1 
fi
