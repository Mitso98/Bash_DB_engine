#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")

#get all tables
declare -a tables_list
tables_indx=0
for table in "$DB_PATH/$current_db/"*; do
    tables_list[$tables_indx]="$(cut -d'/' -f4 <<<"$table")"
    ((tables_indx += 1))
done

## get desired tables
declare -a prepare_tables
indx=0
select opt in "${tables_list[@]}" "exit"; do
    case "$opt" in
    "exit") break ;;
    "$opt")

        if (($indx < $tables_indx)); then
            prepare_tables[$indx]="$opt"
            ((indx += 1))

        else
            break
        fi
        ;;
    esac
done

for table in ${prepare_tables[@]}; do
    echo '+----------------------------------------------------+'
    cat "$DB_PATH/$current_db/$table"
    echo '+----------------------------------------------------+'
done
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
read press
Table_Menu
