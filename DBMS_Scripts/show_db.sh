#!/usr/bin/bash

source ./db_root_path.sh


for dbname in "$DB_PATH"/*
do
	x=${dbname##/}
echo $x
	if [ -d $dbname ]
	then	
		echo $x
	fi	
done 




