#!/bin/bash

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

declare -a col_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate col_type & col_names arrays
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

	col_type[$index]=$type
    col_names[$index]=$col_name

	index+=$((1))

    col_name=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`
    type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`
done

## select column
max_columns=${#col_names[@]}
echo "Choose which column you want to delete from"
echo "Choose from 1 to $max_columns"
read -r col_pos

## check validity
if ! [[ $col_pos =~ ^[0-9]+$ ]] 
then
	
    echo "Enter Vaild Choice !"
    exit 1
elif (( $col_pos > $max_columns || $col_pos <= 0 )) 
then
    echo "PLease enter a valid choice"
    exit 1
fi

## decrease position by one to match array index
(( col_pos -= 1 ))


# Del specific record or whole row
whole_row=0
specific_record=0
select select in "specific_record" "whole_row"
do
    case $select in
        specific_record ) 
            specific_record=1
        break;;
        whole_row ) 
            whole_row=1
        break;;
        * ) echo "Wrong Choice" ;;
    esac
done

## get the target_value
echo "Enter value you want to delete"
read -r target_value

# delete specific record while we can not del PK specefically
if [[ "$specific_record" == "1" ]]
then

    # Will we delte PK
    if [[ "${col_type[$col_pos]}" == *":"* ]]
    then
        echo "You can not delete PK record"
        exit 1
    fi

    max_columns="${#col_names[@]}"
    max_row=`awk -F'|' -v x=1 '{x++;}END{print x}' "$DB_PATH/$current_db/$table_name"`
    found=0
    # scan record by record
    for((j=1;j<max_row;j++))
    do
        for record in "`sed -n "$j p" "$DB_PATH/$current_db/$table_name"`"
        do
            for((i=1;i<=max_columns;i++))
            do
                x="`cut -d'|' -f $i <<< "$record"`"
                if [[ "$x" == "$target_value" && "$(( col_pos + 1 ))" == "$i" && "$j" > "2" ]]
                then
                    found=1
                    echo -n "|" >> "$DB_PATH/$current_db/$table_name.tmp"
                else
                    echo -n "$x|" >> "$DB_PATH/$current_db/$table_name.tmp"
                fi
            done
        done	
        echo '' >> "$DB_PATH/$current_db/$table_name.tmp"
    done

    if [[ "$found" == "0" ]]
    then
	    echo "No values were matched"
	    exit 1
    fi

    echo "Value was succesufully deleted"

    `mv "$DB_PATH/$current_db/$table_name.tmp" "$DB_PATH/$current_db/$table_name"`;
    exit 0
fi

if [ "$whole_row" = "1" ]
then
    
    max_columns="${#col_names[@]}"
    max_row=`awk -F'|' -v x=1 '{x++;}END{print x}' "$DB_PATH/$current_db/$table_name"`
    declare -a target_pos
    target_pos_indx=0

    # scan record by record
    for((j=1;j<max_row;j++))
    do
        for record in "`sed -n "$j p" "$DB_PATH/$current_db/$table_name"`"
        do
            for((i=1;i<=max_columns;i++))
            do

                x="`cut -d'|' -f $i <<< "$record"`"
                if [[ "$x" == "$target_value" && "$(( col_pos + 1 ))" == "$i" && "$j" > 2 ]] 
                then
                    target_pos[$target_pos_indx]=$j
                    (( target_pos_indx += 1 ))
                fi
            done
        done	
    done

    if [[ "$target_pos_indx" == "0" ]]
    then
        echo "No values were found"
        exit 1
    fi

    for((i=0;i<target_pos_indx;i++))
    do  
        x=${target_pos[$i]};
        `sed -i ""$x"d" "$DB_PATH/$current_db/$table_name"`
    done

    echo "Value was succesufully deleted"
    exit 0

fi

