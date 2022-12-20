#!/bin/bash

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

echo '+------------------------------------+'
echo "Enter coloumn name you want to drop"
read -r col_name
echo '+------------------------------------+'

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

if [[ $(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $target_col_pos) == *":"* ]]; then
    echo '+---------------------------------------------------+'
    echo "You can not delte column with a PK constrain"
    echo '+---------------------------------------------------+'
    exit 1
fi

$(cut -d'|' -f $target_col_pos --complement "$DB_PATH/$current_db/$table_name" > "$DB_PATH/$current_db/$table_name.tmp")
$(mv "$DB_PATH/$current_db/$table_name.tmp" "$DB_PATH/$current_db/$table_name")

echo "Column $col_name_ref has been deleted"
