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
    Table_Menu
fi

# get table name
echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"
read -r table_name
while [ ! -f "$DB_PATH/$current_db/$table_name" ]; do
    echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"

    read -r table_name
done

column=0
select count in "all" "column"; do
    case $count in

    all)
        result="$(awk -F'|' 'NR>2{c++}END{print c}' "$DB_PATH/$current_db/$table_name")"
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Number of rows is $result${NC}:raised_hand:   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
        read press
        AlterMenu

        break
        ;;

    column)
        column=1
        break
        ;;
    *) echo "Wrong Choice" ;;
    esac
done

columns_length=$(head -n1 "$DB_PATH/$current_db/$table_name" | grep -o "|" | wc -l)
if [ $column -eq 1 ]; then
    echo -e "\n\t\t\t\t\t\t${BYellow}Which column you want to count? Choose from 1 to $col_pos:  ${NC}\c"
    read -r col_pos

    if ! [[ "$col_pos" =~ ^[0-9]+$ ]]; then
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter valid value${NC}:raised_hand:   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
        read press
        Table_Menu

    elif ((col_pos <= 0 || col_pos > columns_length)); then
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter valid value${NC}:raised_hand:   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
        read press
        Table_Menu
    fi

    # get rows of column without spaces
    counter=$(cat "$DB_PATH/$current_db/$table_name" | cut -d'|' -f$col_pos | sed '/^\s*$/d' | wc -l)
    # substract first two rows
    ((counter -= 2))
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Number of filled fields in the column is $counter${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    AlterMenu
fi
