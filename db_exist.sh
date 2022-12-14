#!/bin/bash

export db_exist=1
if [ $# -eq 1 ]
then 
	if [ -d db_root/$1 ]
	then
		db_exist=0
	fi
else
	echo "PLease enetr a valid input"
	exit 88
fi
