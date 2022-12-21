#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

current_db=$(cat "$DB_PATH/current_db")

declare table_name=""
declare col_name
declare col_type

if [ -z $current_db ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You are not connected to DB${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi

# get table name
echo '+------------------------------------+'
echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]; do
    echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"
    read -r table_name
done
echo '+------------------------------------+'

has_pk=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d ':' -f 2)
# To know whther we have PK at the table or not
if [[ $has_pk == *"pk"* ]]; then
    has_pk=1
else
    has_pk=0
fi

echo '+------------------------------------+'
echo -e "\n\t\t\t\t\t\t${BYellow}Enter column name : ${NC}\c"
read -r col_name
echo '+------------------------------------+'

if ! [[ "$col_name" =~ ^[A-Za-z].* ]]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi

col_is_unique=1
index=1
check_col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
while [[ $check_col_name ]]; do
    ((index += 1))
    if [[ $col_name == $check_col_name ]]; then
        col_is_unique=0
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Column name must be unique${NC}:raised_hand:   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
        read press
        AlterMenu
    else
        check_col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $index)
    fi
done

echo '+------------------------------------+'
echo -e "\n\t\t\t\t\t\t${BYellow}Enter column type: str or int: ${NC}\c"
read -r col_type
echo '+------------------------------------+'

if [[ $col_type != "str" && $col_type != "int" ]]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid data type${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi

echo '+----------------------------------------------------+'
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
echo '+-----------------------------------------------------+'

# modify data
row_type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name")
row_col=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name")

$(sed -i "s/$row_type/$row_type$col_type$has_pk|/" "$DB_PATH/$current_db/$table_name")
$(sed -i "s/$row_col/$row_col$col_name|/" "$DB_PATH/$current_db/$table_name")

clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}${NC}:raised_hand:   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
read press
AlterMenu
