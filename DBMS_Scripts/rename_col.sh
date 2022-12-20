#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then
    echo '+---------------------------------+'
    echo "You are not connected to DB"
    echo '+---------------------------------+'
    exit 1
fi

# get table name
echo '+---------------------------------+'
echo "Enter table name"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]; do
    echo "Enter table name"
    read -r table_name
done
echo '+---------------------------------+'

echo '+--------------------------------------------+'
echo "Enter coloumn name you want to change"
read -r col_name
echo '+--------------------------------------------+'

target_col_pos=1
total_no_col=$(awk -F'|' 'NR==2{print NF; exit}' "$DB_PATH/$current_db/$table_name")
col_name_ref=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $target_col_pos)
col_found=0

# this loop will get total number of columns and target column position
while [[ $total_no_col > 1 ]]; do
    if [[ $col_name_ref != $col_name ]]; then
        ((target_col_pos += 1))
        col_name_ref=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $target_col_pos)
    else
        col_found=1
        break
    fi
    ((total_no_col -= 1))
done

if [[ $col_found == 0 ]]; then
    echo '+---------------------------------+'
    echo "Col name does not exist"
    echo '+---------------------------------+'
    exit 1
fi

echo "Enter the new name"
read -r new

if ! [[ $new =~ ^[A-Za-z].* ]]; then
    echo '+---------------------------------+'
    echo "PLease enter a valid name"
    echo '+---------------------------------+'
    exit 1
fi

echo '+---------------------------------+'
echo "OK!"
echo '+---------------------------------+'
$(sed -i "2s/$col_name/$new/" "$DB_PATH/$current_db/$table_name")
