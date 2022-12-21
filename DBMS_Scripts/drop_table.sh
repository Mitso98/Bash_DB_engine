#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

declare table_name
current_db=$(cat "$DB_PATH/current_db")

if [ -z $current_db ]; then
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}You are not connected to DB${NC}   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}......${NC}\c"
	read press
	Table_Menu
fi

if [ $# -eq 0 ]; then

	echo -e "\n\n\t\t\t\t\t\t${BYellow}Enter table name : ${NC} \c"
	read -r table_name
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]; then
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid name${NC}  ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}......${NC}\c"
	read press
	Table_Menu
fi

# TODO create if [ -f table] rather than loop
list_tables=$(ls -d $DB_PATH/$current_db/* | cut -f4 -d '/')
for tables in $list_tables; do
	if [ $tables = $table_name ]; then
		$(rm "$DB_PATH/$current_db/$table_name")
		clear
		echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}$table_name has been deleted${NC}  ${BBlue}|${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
		echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}......${NC}\c"
		read press
		Table_Menu
	fi
done

clear
echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Table was not found${NC}   ${BBlue}|${NC}"
echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Table Contol Menu${NC}👇......${NC}\c"
read press
Table_Menu
