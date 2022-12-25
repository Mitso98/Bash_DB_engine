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

declare -a col_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate col_type & col_names arrays
type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)

if [ -z $type ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}THis table has no structure!${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    Table_Menu
fi

while [ ! -z "$type" ]; do
    # only add integers
    if [[ $type == "int" ]]; then
        col_type[$index]=$type
        col_names[$index]=$col_name
        index+=$((1))
    fi
    counter+=$((1))

    col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
    type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
done
#####################added
if [ "${#col_names[@]}" == "0" ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You Don't have Column of type int ${NC}  ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    Table_Menu
fi

echo "+---------------------------------------------+"
echo "Choose a column!"
target_col=""
select opt in "${col_names[@]}" "exit"; do
    case "$opt" in
    "exit")
        clear
        ########################################## addedd
        echo -e "${BYellow}\n\n\n\n\n\n\n\n\n\n\\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}......${NC}\c"
        read press
        Table_Menu
        break
        ;;
    "$opt")
        target_col=$opt
        break
        ;;
    esac
done
echo "+---------------------------------------------+"

if [ ! -z "$target_col" ]; then

    # Desired column position
    target_pos=1
    for ((i = 1; i < counter; i++)); do
        value=$(cat "$DB_PATH/$current_db/$table_name" | head -n+2 | tail -n1 | cut -d'|' -f $i)
        echo ">>> $value >>> $target_col "
        if [[ "$value" == "$target_col" ]]; then
            break
        else
            ((target_pos++))
        fi
    done

    sum=$(awk -F'|' -v pos=$target_pos -v sum=0 'NR>2{sum+=$pos}END{print sum}' "$DB_PATH/$current_db/$table_name")
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Total sum of column '$target_col' is: $sum${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    Table_Menu

else
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}No values were choosen!$target_col' is: $sum${NC}:raised_hand:   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}:point_down:......${NC}\c"
    read press
    Table_Menu
fi
