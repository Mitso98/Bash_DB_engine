#!/usr/bin/bash

source ./db_root_path.sh

list=`ls -d $DB_PATH/*/ | cut -f3 -d '/' `

for dbname in "$list"
do
      
       echo  "$dbname"
		
done 

