#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")

declare table_name=""
declare col_name
declare col_type

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

has_pk=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d ':' -f 2)
# To know whther we have PK at the table or not
if [[ $has_pk == *"pk"* ]]; then
    has_pk=1
else
    has_pk=0
fi

echo "Enter column name"
read -r col_name

if ! [[ "$col_name" =~ ^[A-Za-z].* ]]; then
    echo "PLease enter a valid name"
    exit 1
fi

col_is_unique=1
index=1
check_col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
while [[ $check_col_name ]]; do
    ((index += 1))
    if [[ $col_name == $check_col_name ]]; then
        echo "Column name must be unique"
        col_is_unique=0
        exit 1
    else
        check_col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $index)
    fi
done

echo "Enter column type: str or int"
read -r col_type

if [[ $col_type != "str" && $col_type != "int" ]]; then
    echo "PLease enter a valid data type"
    exit 1
fi

# if table has no PK u may assghin one
if [ $has_pk -eq 0 ]; then
    echo "Do you want to assighn this column as PK"
    select type in "y" "n"; do
        case $type in
        y)
            has_pk=":pk"
            break
            ;;
        n)
            has_pk=""
            break
            ;;
        *) echo "Wrong Choice" ;;
        esac
    done
else
    has_pk=""
fi

# modify data
row_type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name")
row_col=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name")

$(sed -i "s/$row_type/$row_type$col_type$has_pk|/" "$DB_PATH/$current_db/$table_name")
$(sed -i "s/$row_col/$row_col$col_name|/" "$DB_PATH/$current_db/$table_name")

exit 0
