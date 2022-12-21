#!/usr/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

if [ ! -z "$DB_PATH/current_db" ]; then
    curr=$(cat $DB_PATH/current_db)
    echo "" >"$DB_PATH/current_db"

    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}you are Disconnected from ${BYellow}$curr${NC}${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To DMBS Menu${NC}👇......${NC}\c"
    read press
    mainMenu

else
    echo '+----------------------------------------------------+'
    echo ""
    echo '+----------------------------------------------------+'
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}you are not connected to any Databases ${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To DMBS Menu${NC}👇......${NC}\c"
    read press
    mainMenu
fi
