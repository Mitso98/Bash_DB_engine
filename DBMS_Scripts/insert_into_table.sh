#!/bin/bash
source DBMS_Scripts/db_root_path.sh
current_db=$(cat "$DB_PATH/current_db")
declare table_name=""
declare -a data_type
declare -a col_names
typeset -i counter=1
typeset -i index=0

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
	AlterMenu
fi

#store data types & col_names
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
	data_type[$index]=$type
	col_names[$index]=$col_name

	index+=$((1))

	col_name=$(awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)
	type=$(awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter)

done

# get user inputs
exit_condition="n"
col_no=$index
index=0
data=""
counter=1
dublicate=0
typeset -a row

while [[ $index < $col_no ]]; do
	echo -e "\n\t\t\t\t\t\t${BYellow}column type: ${NC}${BGreen}(${data_type[$index]})${NC} ${BYellow}column name:${NC} ${BGreen}${col_names[$index]}${NC} ${BYellow}:${NC}  \c"
	read -r data

	# this column is PK
	if [[ ${data_type[$index]} == *":"* ]]; then
		if [ -z $data ]; then
			echo "\n\t\t\t\t\t\t${BRed}This column can not be empty${NC}"
			continue
		fi
		for x in $(cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $counter); do
			if [[ $data == $x ]]; then
				echo '+---------------------------------+'
				echo "\n\t\t\t\t\t\t${BRed}PK must be unique${NC}"
				echo '+---------------------------------+'
				dublicate=1
				break
			fi
		done
		if [[ $dublicate == 1 ]]; then
			dublicate=0
			continue
		fi

	fi

	# check for integer
	if [[ ${data_type[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]; then
		row[$index]="$data|"
	elif [[ ${data_type[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]; then
		row[$index]="$data|"
	elif [ -z $data ]; then
		row[$index]="$data|"
	elif [ -z $data ]; then
		row[$index]="$data|"
	else

		echo "\n\t\t\t\t\t\t${BRed}PLease enter valid data${NC}"

		continue
	fi
	((counter += 1))
	((index += 1))
done

for x in "${row[@]}"; do
	echo -e "$x\c" >>"$DB_PATH/$current_db/$table_name"
done
echo "" >>"$DB_PATH/$current_db/$table_name"

clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You Inserted To Table Successfuly ${NC}😊   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
read press
Table_Menu
