#!/bin/bash
# Create data base

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

declare DB

#check whether root folder exist
if [ ! -d $DB_PATH ]; then
	mkdir $DB_PATH
	touch $DB_PATH/current_db
fi

# user entered DB name
if [ $# -eq 0 ]; then

	echo -e "\n\n\t\t\t\t\t\t${BYellow}Enter DB name : ${NC}\c"
	read -r DB
fi
if [ -z "$DB" ]; then
	clear
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter vaild Input${NC}✋   ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
	read press
	mainMenu
fi

if [[ $DB =~ ^[A-Za-z].* ]]; then

	if [ -d "$DB_PATH/$DB" ]; then
		clear
		echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}DB already exists${NC}✋   ${BBlue}|${NC}"
		echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
		echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
		read press
		mainMenu
	fi
	clear
	mkdir "$DB_PATH/$DB"
	echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t======================================${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t|${NC}   ${BWhite}${BGreen}$DB${NC} is Created Successfully${NC}👌  ${BBlue}|${NC}"
	echo -e "${BBlue}\t\t\t\t\t\t=======================================${NC}\n\n"
	echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
	read press
	mainMenu
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
