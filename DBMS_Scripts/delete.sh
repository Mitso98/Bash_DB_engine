#!/bin/bash

source ./db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then
    echo "You are not connected to DB"
    exit 1
fi

# get table name
echo "Enter table name"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]; do
    echo "Enter table name"
    read -r table_name
done

declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate data_type & col_names arrays
type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)

if [ -z $type ]; then
    echo "THis table has no structure!"
    exit 1
fi

while [ ! -z "$type" ]; do
    counter+=$((1))

    data_type[$index]=$type
    col_names[$index]=$col_name

    index+=$((1))

    col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
    type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
done

## select column
max_columns=${#col_names[@]}
echo "Choose which column you want to delete from"
echo "Choose from 1 to $max_columns"
read -r col_pos

## check validity
if ! [[ $col_pos =~ ^[0-9]+$ ]]; then

    echo "Enter Vaild Choice !"
    exit 1
elif (($col_pos > $max_columns || $col_pos <= 0)); then
    echo "PLease enter a valid choice"
    exit 1
fi

## decrease position by one to match array index
((col_pos -= 1))

## Delete Row with PK

# Del specific record or whole row
whole_row=0
specific_record=0
select select in "specific_record" "whole_row"; do
    case $select in
    specific_record)
        specific_record=1
        break
        ;;
    whole_row)
        whole_row=1
        break
        ;;
    *) echo "Wrong Choice" ;;
    esac
done

# delete specific record wehile we can not del PK specifically
if [ $specific_record -eq 1 ]; then
    # Will we delte PK
    if [[ ${col_type[$col_pos]} == *":"* ]]; then
        echo "You can not delte PK record"
        exit 1
    fi

fi
