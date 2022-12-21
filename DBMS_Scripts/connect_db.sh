#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

declare DB

#show existed DB to help the user

ls $DB_PATH/*/ >/dev/null 2>&1

if [ $? == 0 ]; then

	echo -e "${BBlue}\n\n\t\t\t\t\t\t===================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|  ${NC}${BGreen}Your DataBases ${NC}${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t===================${NC}"

	list=$(ls -d $DB_PATH/*/ | cut -f3 -d '/')
	for dbname in $list; do

		echo -e "\t\t\t\t\t\t    |   ${BWhite}$dbname${NC}   |"
		echo -e "\t\t\t\t\t\t${BBlue}+-------------------+${NC}"
	done

else
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=======================================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}NO DataBases created yet!${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t=======================================${NC}\n"
	echo -e "${BYellow}\t\t\t\t\t\t (Back To Main Menu) Press any👇......${NC}\c"
	read press
	clear
	mainMenu

fi

if [ $# -eq 0 ]; then

	echo -e "\n\t\t\t\t\t\t${BYellow}Enter DB name : ${NC}\c"
	read -r DB
fi
if [[ $DB =~ ^[A-Za-z].* ]]; then

	if [ -d "$DB_PATH/$DB" ]; then

		echo "$DB" >$DB_PATH/current_db
		Table_Menu

	else

		clear
		echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=======================================${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Please enter a valid input!${NC}   ${BBlue}|${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t=======================================${NC}\n\n"
		echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
		read press
		clear
		mainMenu

	fi
else
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=======================================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Please enter a valid input!${NC}   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t=======================================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
	read press
	clear
	mainMenu
fi
