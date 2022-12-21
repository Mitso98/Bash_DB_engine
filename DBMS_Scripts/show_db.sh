#!/usr/bin/bash

source DBMS_Scripts/db_root_path.sh
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

       echo -e "${BBlue}\n\t\t\t\t\t    ==============================${NC}"
       echo -e "${BBlue}\t\t\t\t\t    |${NC}      ${BWhite}Back To Main Menu${NC}👇   ${BBlue}|${NC}"
       echo -e "${BBlue}\t\t\t\t\t    ==============================${NC}\n"
       echo -e "${BYellow}\t\t\t\t\t\tPress any Key......${NC}\c"
       read press
       clear
       mainMenu
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
