#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
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

# get table name
echo -e "\n\n\t\t\t\t\t\t${BYellow}EEnter table name : ${NC}\c"
read -r table_name
if [ ! -f "$DB_PATH/$current_db/$table_name" ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
fi

declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate data_type & col_names arrays
type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)

if [ -z $type ]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}This table has no structure!${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
fi

while [ ! -z "$type" ]; do
    counter+=$((1))

    data_type[$index]=$type
    col_names[$index]=$col_name

    index+=$((1))

    col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
    type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
done

# select all
echo -e "\n\t\t${BYellow}Select From table ($table_name):${NC}"
Choices=("Select All data at the table" "Select All data where ? ")
PS3="Enter Your Choice: "
select select in "${Choices[@]}"; do
    case $select in
    "${Choices[0]}")
        echo -e "\n\t\t|=============|"
        echo -e "\t\t|   $table_name     |"
        echo -e "\t\t|=============|"
        echo '+----------------------------------+'
        sed '1d' "$DB_PATH/$current_db/$table_name" | column -t -s "|"
        echo -e '+-----------------------------------+\n'
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
        read press
        Table_Menu
        break
        ;;
    "${Choices[1]}") break ;;
    *) echo "Wrong Choice" ;;
    esac
done

max_columns=${#col_names[@]}
echo -e "\n\t\t\t\t\t\t${BYellow}Choose which column you want to run query at${NC}"
echo -e "\n\t\t\t\t\t\t${BYellow}Choose from 1 to $max_columns : ${NC}\c"
read -r choice

## check input
if ! [[ $choice =~ ^[0-9]+$ ]]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}This table has no structure!${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
elif (($choice > $max_columns || $choice <= 0)); then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid choice${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
fi

echo -e "\n\t\t\t\t\t\t${BYellow}Where column $choice : ${NC}\c "
read -r target_value

values=$(awk -F'|' -v x="$target_value" -v pos=$choice 'NR>2{if($pos == x){ print}}' "$DB_PATH/$current_db/$table_name")

if [ "$values" ]; then
    e=$(sed -n '2p' "$DB_PATH/$current_db/$table_name")

    echo "$e" >"$DB_PATH/$current_db/$table_name.tmp"
    echo "$values" >>"$DB_PATH/$current_db/$table_name.tmp"

    echo -e "\n\t\t|=============|"
    echo -e "\t\t|   $table_name     |"
    echo -e "\t\t|=============|"
    echo '+----------------------------------+'

    column -t -s "|" "$DB_PATH/$current_db/$table_name.tmp"
    rm "$DB_PATH/$current_db/$table_name.tmp"

    echo -e '+----------------------------------+\n'
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
else

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}No values were found${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
    read press
    Table_Menu
fi
