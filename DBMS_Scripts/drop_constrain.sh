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

declare -a col_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate col_type & col_names arrays
type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)

if [ -z $type ]; then
    echo '+---------------------------------+'
    echo "THis table has no structure!"
    echo '+---------------------------------+'
    exit 1
fi

while [ ! -z "$type" ]; do
    counter+=$((1))

    col_type[$index]=$type
    col_names[$index]=$col_name

    index+=$((1))

    col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
    type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
done

## select column
max_columns=${#col_names[@]}
echo '+---------------------------------+'
echo "Choose which column you want to drop it's constrain"
echo "Choose from 1 to $max_columns"
read -r col_pos
echo '+---------------------------------+'

## check validity
if ! [[ $col_pos =~ ^[0-9]+$ ]]; then
    echo '+---------------------------------+'
    echo "Enter Vaild Choice !"
    echo '+---------------------------------+'
    exit 1
elif (($col_pos > $max_columns || $col_pos <= 0)); then
    echo '+---------------------------------+'
    echo "PLease enter a valid choice"
    echo '+---------------------------------+'
    exit 1
fi

## decrease position by one to match array index
((col_pos -= 1))

if [[ "${col_type[$col_pos]}" != *":"* ]]; then
    echo '+---------------------------------+'
    echo "This column has no constrains"
    echo '+---------------------------------+'
    exit 1
fi

max_columns="${#col_names[@]}"
max_row=$(awk -F'|' -v x=1 '{x++;}END{print x}' "$DB_PATH/$current_db/$table_name")
found=0
# scan record by record
for ((j = 1; j < max_row; j++)); do
    for record in "$(sed -n "$j p" "$DB_PATH/$current_db/$table_name")"; do
        for ((i = 1; i <= max_columns; i++)); do
            x="$(cut -d'|' -f $i <<<"$record")"
            if [[ "$((col_pos + 1))" == "$i" && "$j" == "1" ]]; then
                found=1
                echo -n "$(sed 's/:pk/|/' <<<"$x")"
                echo -n "$(sed 's/:pk/|/' <<<"$x")" >>"$DB_PATH/$current_db/$table_name.tmp"
            else
                echo -n "$x|" >>"$DB_PATH/$current_db/$table_name.tmp"
            fi
        done
    done
    echo '' >>"$DB_PATH/$current_db/$table_name.tmp"
done

if [[ "$found" == "0" ]]; then
    echo '+---------------------------------+'
    echo "No values were matched"
    echo '+---------------------------------+'
    exit 1
fi
echo '+---------------------------------+'
echo "Constrain has been droped"
echo '+---------------------------------+'

$(mv "$DB_PATH/$current_db/$table_name.tmp" "$DB_PATH/$current_db/$table_name")
exit 0
