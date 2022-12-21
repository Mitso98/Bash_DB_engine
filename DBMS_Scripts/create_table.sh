#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

declare table_name
declare -i ColNum
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then

	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You are not connected to DB${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
	read press
	Table_Menu
fi

if [ $# -eq 0 ]; then

	echo -e "\n\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC}\c"

	read -r table_name
fi
if [ -z "$table_name" ]; then
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter vaild Input${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
	read press
	Table_Menu
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]; then
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=====================================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t========================================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
	read press
	Table_Menu
fi

# check if folder is empty do not excute below command
if [ "$(ls -A "$DB_PATH/$current_db")" ]; then
	list_tables=$(ls -d $DB_PATH/$current_db/* | cut -f4 -d '/')
	for tables in $list_tables; do
		table_name_lower=$(echo "${table_name,,}")
		tables_lower=$(echo "${tables,,}")

		if [ "$tables_lower" = "$table_name_lower" ]; then

			clear
			echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
			echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}This table already exists${NC}✋   ${BBlue}|${NC}"
			echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
			echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
			read press
			Table_Menu
		fi

	done

fi

echo -e "\n\t\t\t\t\t\t${BYellow}Enter Number of Colmns : ${NC}\c"
read -r Col_Num

if [ "$Col_Num" = "0" ]; then

	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter Number not zero!!${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
	read press
	Table_Menu
fi

if [[ ! "$Col_Num" =~ ^[0-9]+$ ]]; then

	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter Vaild Number !!${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
	read press
	Table_Menu
fi

declare -i counter=1
declare col_type
declare -a Columns_dt
declare -a Columns_names
declare col_name
declare col_type

while [ $counter -le $Col_Num ]; do

	echo -e "\n\t\t\t\t\t\t${BYellow}Enter Name of Column $counter ${NC}: \c "
	read -r col_name

	if ! [[ "$col_name" =~ ^[A-Za-z].* ]]; then
		clear
		echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t======================================${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}✋   ${BBlue}|${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t==============================================${NC}\n\n"
		echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
		read press
		Table_Menu
	fi

	for col in ${Columns_names[@]}; do
		col_name_lower=$(echo "${col_name,,}")
		col_lower=$(echo "${col,,}")

		if [ "$col_name_lower" = "$col_lower" ]; then
			clear
			echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
			echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}This Column already existed${NC}✋   ${BBlue}|${NC}"
			echo -e "${BBlue}\t\t\t\t\t\t============================================${NC}\n\n"
			echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
			read press
			Table_Menu
		fi

	done

	echo -e "\t${BYellow}Type of Column $col_name:${NC} "
	PS3="	Enter your Choice >"
	select type in "int" "str"; do
		case $type in
		int)
			col_type="int"
			break
			;;
		str)
			col_type="str"
			break
			;;
		*) echo "\t${BRed}Wrong Choice${NC}" ;;
		esac
	done
	echo ""
	pk=0
	for col in ${Columns_dt[@]}; do
		if [[ $col = *":pk"* ]]; then
			pk=1
			break
		fi
	done

	echo ""
	if [ $pk = 0 ]; then

		echo -e "\t${BYellow}Make PrimaryKey ? ${NC}"
		PS3="	Enter your Choice >"
		select Choice in "yes" "no"; do
			case $Choice in
			yes)
				col_type="$col_type:pk"
				break
				;;
			no) break ;;
			*) echo "\t${BRed}Wrong Choice${NC}" ;;
			esac
		done
	fi

	Columns_names[$counter]="$col_name"
	Columns_dt[$counter]="$col_type"

	counter=$counter+1
done

for col in ${Columns_dt[@]}; do
	if [[ $col = *":pk"* ]]; then
		pk=1
		break
	else
		pk=0

	fi
done
touch "$DB_PATH/$current_db/$table_name"

table_file="$DB_PATH/$current_db/$table_name"

for col in ${Columns_dt[@]}; do
	printf ""$col"|" >>"$table_file"
done
printf "%s\n" >>"$table_file"
for col in "${Columns_names[@]}"; do
	coll=$(echo ""$col"|")
	printf "$coll" >>"$table_file"
done
printf "%s" >>"$table_file"
clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t========================================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}The Table Created Successfuly :)${NC}😊   ${BBlue}|${NC}"

if [ $pk = 0 ]; then
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Your Table has not  PK Column :):${NC}🤓   ${BBlue}|${NC}"
	echo ""

fi
echo -e "${BBlue}\t\t\t\t\t\t==================================================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......\c"
read press
Table_Menu
