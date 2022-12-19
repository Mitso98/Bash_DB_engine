#!/bin/bash

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

declare table_name=""
declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0
declare -i pk_index=1
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

declare -i Num_records=`awk '{print}' "$DB_PATH/$current_db/$table_name" | sed '1,2d' | wc -l`

######### get pk index ###############
	for col in ${Columns_dt[@]}
	    do	
		    if [[ $col = *":pk"* ]] 
			    then 
                break 
                fi
            pk_index=$pk_index+1        
		done
        







#store data types & col_names
type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f 1`
col_name=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f 1`

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

    col_name=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`
    type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`

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
	if [[ ${data_type[$index]} == *":"* ]]  
	then
		if [ -z $data ]
		then
			echo "This column can not be empty"
			continue
		fi	
 			declare -i i=1
            while [ $i -le $Num_records ] 
            do
            	x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                if [ "$x" = "$data" ]
                    then 
                     echo "PK must be unique"
                    dublicate=1
					break
                fi	
                i=$i+1
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
		row[$index]="$data|"
	elif [[ ${data_type[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]
	then
		row[$index]="$data|"
	elif [ -z $data ]
    then
        row[$index]="$data|"
    else
		echo "PLease enter valid data"
		continue
	fi	
		(( counter += 1))
    	(( index += 1 ))
done

echo  ${row[@]} >> "$DB_PATH/$current_db/$table_name"  