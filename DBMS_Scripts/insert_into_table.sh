#!/bin/bash

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

declare table_name=""
declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

if [ -z $current_db ]
then
	echo "You are not connected to DB"
	exit 1
fi

# get table name
echo "Enter table name"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]
do
    echo "Enter table name"
    read -r table_name
done


#store data types & col_names
type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d ',' -f 1`
col_name=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d ',' -f 1`

if [ -z $type ]
then
    echo "THis table has no structure!"
    exit 1
fi

while [ ! -z "$type" ]
do
    counter+=$((1))

	data_type[$index]=$type
    col_names[$index]=$col_name

	index+=$((1))

    col_name=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d ',' -f $counter`
    type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d ',' -f $counter`

done

# get user inputs
exit_condition="n"
col_no=$index
index=0
data=""
counter=1
dublicate=0
typeset -a row

while [[ $index < $col_no ]]
do
    	echo "column type: ${data_type[$index]} column name: ${col_names[$index]}";
	read -r data
	
	# this column is PK	
	if [[ ${data_type[$index]} == *"|"* ]]  
	then
		if [ -z $data ]
		then
			echo "This column can not be empty"
			continue
		fi	
		for x in `cat "$DB_PATH/$current_db/$table_name" | cut -d ',' -f 1`
		do
	 		if [[ $data == $x ]]
			then
				echo "PK must be unique"
				dublicate=1
				break
			fi
		done
		
		if [[ $dublicate == 1 ]]
		then 
			dublicate=0
			continue
		fi
		
	fi
	
	
	# check for integer
	if [[ ${data_type[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]
	then 
		row[$index]="$data,"
	elif [[ ${data_type[$index]} == *"string"* && $data =~ ^[A-Za-z].* ]]
	then
		row[$index]="$data,"
	elif [ -z $data ]
    then
        row[$index]="$data,"
    else
		echo "PLease enter valid data"
		continue
	fi	
	
    	(( index += 1 ))
done

echo -e ${row[@]} >> "$DB_PATH/$current_db/$table_name"  

