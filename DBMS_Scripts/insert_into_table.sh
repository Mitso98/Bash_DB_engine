#!/bin/bash

## still in progress

source ./db_root_path.sh
current_db=`cat "$DB_PATH/current_db"`
declare -a col_names
typeset -i counter=0

while true
do
    echo "Enter column name"
    read -r col_names[counter]

    echo "Do you want to continue?"
    read -r cont

    if [[ "$cont" != "y" ]] && [[ "$cont" != "yes" ]]
    then
        break
    fi

    counter=$((1))
done

echo ${col_names[@]}




