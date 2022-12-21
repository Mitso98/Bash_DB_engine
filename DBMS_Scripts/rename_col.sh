#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

current_db=$(cat "$DB_PATH/current_db")

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
echo '+---------------------------------+'
echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]; do
    echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"
    read -r table_name
done
echo '+---------------------------------+'

echo '+--------------------------------------------+'
echo -e "\n\t\t\t\t\t\t${BYellow}Enter coloumn name you want to change: ${NC}\c"
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
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Col name does not exist${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi

echo -e "\n\t\t\t\t\t\t${BYellow}Enter the new name: ${NC}\c"
read -r new

if ! [[ $new =~ ^[A-Za-z].* ]]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi

$(sed -i "2s/$col_name/$new/" "$DB_PATH/$current_db/$table_name")
clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}OK!${NC}:raised_hand:   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
read press
AlterMenu
