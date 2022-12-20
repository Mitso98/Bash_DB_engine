#!/bin/bash

declare -a index
declare -a updated
index[1]="1"
index[2]="2"
updated[1]="6"
updated[2]="ahmed"
declare -a row_indexs

n=`awk -F"|" -v pos=2 -v target_value="omar" '{if($pos==target_value){print NR;}}' $1`

declare -i i=1
for x in `cut -d " " -f1 <<< $n`
do

    row_indexs[$i]=$x
    i=$i+1
done

updated_row="55|sasa|"

#for x in "${row_indexs[@]}"
#do
    if [[ !" ${row_indexs[@]} " =~ "" ]]; then
    # commands here when array doesn't contains a value
    echo found
    fi
   # old_row=`awk -F "|" -v pos=$x 'NR==pos{print $0}' test1`
    
   #echo $old_row

   #sed -i ''$x's/'"$old_row"'/'"$updated_row"'/g' test1

#done





<< "COMMENT"
x=`awk -F"|" '{if($2=="omar"){{sub($2,"ahmed")};print $2}}1 ' $1 | sed -n "${n[1]}"p `

echo "${n[1]}"
echo "$x"

oldValue=`awk -F"|" '{if($2=="omar"){print $2}} ' $1`
echo "$oldValue"


#sed -i ''${n[1]}'s/'$oldValue'/'$x'/g' $1



for i in "${index[@]}"
    do
    echo "${updated[i]}"
    done

COMMENT
