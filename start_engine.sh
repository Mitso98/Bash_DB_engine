#!/bin/bash

if [ $# -gt 0 ]
then
	echo "This function accepts no arguments"
	exit 1
else
	if [ -d $HOME/db_root ]
	then
		echo "Root folder already exists"
	else
		mkdir db_root
		mkdir db_root/meta_data
		touch db_root/meta_data/existed_db
		touch db_root/meta_data/current_db
		exit 0
	fi 
fi
