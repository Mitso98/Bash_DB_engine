#!/bin/bash

source DBMS_Scripts/db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You are not connected to DB${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu
fi

# get all tables
declare -a tables_list
tables_indx=0
for table in "$DB_PATH/$current_db/"*; do
    tables_list[$tables_indx]="$(cut -d'/' -f4 <<<"$table")"
    ((tables_indx += 1))
done

echo -e "${BBlue}\n\n\t\t\t\t\t\t===================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|  ${NC}${BGreen}Your Tables ${NC}${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t===================${NC}"

list=$(ls -d $DB_PATH/*/ | cut -f3 -d '/')
for t in "${tables_list[@]}"; do

    echo -e "\t\t\t\t\t\t    |   ${BWhite}$t${NC}   |"
    echo -e "\t\t\t\t\t\t${BBlue}+-------------------+${NC}"
done

echo -e "${BBlue}\n\t\t\t\t\t    ======================================${NC}"
echo -e "${BBlue}\t\t\t\t\t    |${NC}      ${BWhite}Back To Table Control Menu${NC}👇   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t    ======================================${NC}\n"
echo -e "${BYellow}\t\t\t\t\t\tPress any Key......${NC}\c"
read press
clear
Table_Menu
