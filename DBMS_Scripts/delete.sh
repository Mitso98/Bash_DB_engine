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

# get table name
echo -e "\n\t\t\t\t\t\t${BYellow}Enter table name :${NC} \c"
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

declare -a col_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

#populate col_type & col_names arrays
type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)
col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f 1)

if [ -z $type ]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}This table has no structure!${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu
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

print=$(awk -F'|' 'NR==2{print}' "$DB_PATH/$current_db/$table_name")
echo -e "${BBlue}\n\n\t\t\t\t\t\t==============${BWhite}Columns${NC}${BBlue}========================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t${NC}      ${BWhite}$print${NC}   ${BBlue}${NC}"
echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"

echo -e "\n\t\t\t\t\t\t${BYellow}Choose which column you want to delete from${NC}"
echo -e "\n\t\t\t\t\t\t${BYellow}Choose from 1 to $max_columns : ${NC}\c"
read -r col_pos

## check validity
if ! [[ $col_pos =~ ^[0-9]+$ ]]; then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter Vaild Choice !${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu
elif (($col_pos > $max_columns || $col_pos <= 0)); then

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid choice${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu
fi

## decrease position by one to match array index
((col_pos -= 1))

# Del specific record or whole row
whole_row=0
specific_record=0
echo -e "\n\t\t${BYellow}You want to delete ?${NC}"
PS3="       Enter your Choice >"

select select in "specific_record" "whole_row"; do
    case $select in
    specific_record)
        specific_record=1
        break
        ;;
    whole_row)
        whole_row=1
        break
        ;;
    *) echo "Wrong Choice" ;;
    esac
done

## get the target_value
echo -e "\n\t\t\t\t\t\t${BYellow}Enter value you want to delete :${NC} \c"
read -r target_value

# delete specific record while we can not del PK specefically
if [[ "$specific_record" == "1" ]]; then

    # Will we delte PK
    if [[ "${col_type[$col_pos]}" == *":"* ]]; then

        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You can not delete PK record${NC}✋   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
        read press
        Table_Menu
    fi

    max_columns="${#col_names[@]}"
    max_row=$(awk -F'|' -v x=1 '{x++;}END{print x}' "$DB_PATH/$current_db/$table_name")
    found=0
    # scan record by record
    for ((j = 1; j < max_row; j++)); do
        for record in "$(sed -n "$j p" "$DB_PATH/$current_db/$table_name")"; do
            for ((i = 1; i <= max_columns; i++)); do
                x="$(cut -d'|' -f $i <<<"$record")"
                exit
                if [[ "$x" == "$target_value" && "$((col_pos + 1))" == "$i" && "$j" > "2" ]]; then
                    found=1
                    echo -n "|" >>"$DB_PATH/$current_db/$table_name.tmp"
                else
                    echo -n "$x|" >>"$DB_PATH/$current_db/$table_name.tmp"
                fi
            done
        done
        echo '' >>"$DB_PATH/$current_db/$table_name.tmp"
    done

    if [[ "$found" == "0" ]]; then

        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}No values were matched${NC}✋   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
        read press
        Table_Menu
    fi
    $(mv "$DB_PATH/$current_db/$table_name.tmp" "$DB_PATH/$current_db/$table_name")
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Value was succesufully deleted${NC}😊   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu

fi

if [ "$whole_row" = "1" ]; then

    max_columns="${#col_names[@]}"
    max_row=$(awk -F'|' -v x=1 '{x++;}END{print x}' "$DB_PATH/$current_db/$table_name")
    declare -a target_pos
    target_pos_indx=0

    # scan record by record
    for ((j = 1; j < max_row; j++)); do
        for record in "$(sed -n "$j p" "$DB_PATH/$current_db/$table_name")"; do
            for ((i = 1; i <= max_columns; i++)); do

                x="$(cut -d'|' -f $i <<<"$record")"
                if [[ "$x" == "$target_value" && "$((col_pos + 1))" == "$i" && "$j" > 2 ]]; then
                    target_pos[$target_pos_indx]=$j
                    ((target_pos_indx += 1))
                fi
            done
        done
    done

    if [[ "$target_pos_indx" == "0" ]]; then

        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}No values were found${NC}✋   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
        read press
        Table_Menu
    fi

    for ((i = 0; i < target_pos_indx; i++)); do
        x=${target_pos[$i]}
        $(sed -i ""$x"d" "$DB_PATH/$current_db/$table_name")
    done

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Value was succesufully deleted${NC}😊   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
    read press
    Table_Menu
fi
