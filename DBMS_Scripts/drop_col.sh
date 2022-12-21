#!/bin/bash

source DBMS_Scripts/db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You are not connected to DB${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

# get table name

echo -e"\n\t\t\t\t\t\t${BYellow}Enter table name :${NC}  \c"
read -r table_name

if [ -z "$table_name" ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter vaild Input${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

if [ ! -f "$DB_PATH/$current_db/$table_name" ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

echo -e "\n\t\t\t\t\t\t${BYellow}Enter coloumn name you want to drop :${NC} \c"
read -r col_name

target_col_pos=1
total_no_col=$(awk -F'|' 'NR==2{print NF; exit}' "$DB_PATH/$current_db/$table_name")
col_name_ref=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $target_col_pos)
col_found=0

# this loop will get total number of columns and target column position
while [[ $total_no_col > 1 ]]; do
    if [[ "$col_name_ref" != "$col_name" ]]; then
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
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Col name does not exist${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

if [[ $(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $target_col_pos) == *":"* ]]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You can not delte column with a PK constrain${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    AlterMenu
fi

$(cut -d'|' -f $target_col_pos --complement "$DB_PATH/$current_db/$table_name" >"$DB_PATH/$current_db/$table_name.tmp")
$(mv "$DB_PATH/$current_db/$table_name.tmp" "$DB_PATH/$current_db/$table_name")

echo ""
clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Column ${BYellow}$col_name_ref{NC} has been deleted${NC}✋   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Alter table Menu${NC}👇......${NC}\c"
read press
AlterMenu
