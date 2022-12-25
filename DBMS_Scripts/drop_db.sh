#!/bin/bash

# IMPORT DB_PATH variable
source DBMS_Scripts/db_root_path.sh

declare DB

current_db=$(cat $DB_PATH/current_db)
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

########################### drop##################
echo -e "\n\t\t\t\t\t\t${BYellow}Enter DB Name to Drop :${NC}\c"
read -r DB

if [ -z "$DB" ]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Enter vaild Input${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
    read press
    mainMenu
fi

if ! [[ $DB =~ ^[A-Za-z].* ]]; then
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t======================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}   ${BWhite} PLease enter a valid DB name${NC}✋ ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t=======================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
    read press
    mainMenu

fi

if [ -d "$DB_PATH/$DB" ]; then

    if [ "$DB" = "$current_db" ]; then

        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t===============================================================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}    ${BWhite}Your now connected to ${BGreen}$DB${NC} please exit from ${BGreen}$DB${NC} first${NC}✋ ${BBlue} | ${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t=================================================================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
        read press
        mainMenu

    else

        clear
        rm -r "$DB_PATH/$DB"

        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==================================================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}The ${BGreen}$DB${NC} Data Base Droped Successfuly${NC}👌   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==================================================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
        read press
        mainMenu

    fi
else
    clear
    echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t===========================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}PLease enter a valid DB name${NC}✋   ${BBlue}|${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t===========================================${NC}\n\n"
    echo -e "${BYellow}\t\t\t\t\t\t${BWhite}Back To Main Menu${NC}👇......${NC}\c"
    read press
    mainMenu

fi
