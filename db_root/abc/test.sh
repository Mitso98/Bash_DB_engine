#!/bin/bash

declare -a arr
declare row

col_pos=2
col_names=("c1" "c2" "c3" "")
col_type=("int" "str:pk" "int")
max=${#col_names[@]}


whole_row=0
specific_record=0
select select in "specific_record" "whole_row"
do
    case $select in
    specific_record ) 
        specific_record=1
    break;;
    whole_row ) 
        whole_row=1
    break;;
    * ) echo "Wrong Choice" ;;
    esac
done

## decrease position by one to match array index
(( col_pos -= 1 ))

# delete specific record
if [ $specific_record -eq 1 ]
then
    # Will we delte PK
    if [[ ${col_type[$col_pos]} == *":"* ]]
    then
        echo "You can not delte PK record"
        exit 1
    fi
fi



	
