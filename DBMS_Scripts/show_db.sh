#!/usr/bin/bash

source ./db_root_path.sh


for dbname in `ls -d $DB_PATH/*/ | cut -f3 -d'/' `

do
       echo $dbname
		
done 

