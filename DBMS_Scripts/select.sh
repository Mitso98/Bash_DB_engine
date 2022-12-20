#!/bin/bash

## exit after where
## enhance UI

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

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

declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate data_type & col_names arrays
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

# select all
select select in "all" "where"
do
    case $select in
    all ) 
        for x in "`awk 'NR>2{print p}{p=$0}' "$DB_PATH/$current_db/$table_name" `"
        do
	        echo "$x"
        done
        exit 0
    break;;
    where ) break;;
    * ) echo "Wrong Choice" ;;
    esac
done


max_columns=${#col_names[@]}
echo "Choose which column you want to run query at:"
echo "Choose from 1 to $max_columns"
read -r choice

## check input
if ! [[ $choice =~ ^[0-9]+$ ]] 
then
	
    echo "Enter Vaild Choice !"
    exit 1
elif (( $choice > $max_columns || $choice <= 0 )) 
then
    echo "PLease enter a valid choice"
    exit 1
fi


echo "Where column $choice = 'enter value' "
read -r target_value


values=`awk -F'|' -v x="$target_value" -v pos=$choice 'NR>2{if($pos == x){ print}}' "$DB_PATH/$current_db/$table_name"`

if [ "$values" ]
then
	for x in "`awk -F'|' -v x="$target_value" -v pos=$choice 'NR>2{if($pos == x){ print}}' "$DB_PATH/$current_db/$table_name"`"
	do
		echo "$x"
	done
else
	echo "No values were found"
fi

#!/bin/bash

## exit after where
## enhance UI

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`

if [ -z $current_db ]
then
	echo "You are not connected to DB"
	exit 1
fi
