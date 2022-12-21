#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'        # No Color
BGreen='\033[1;32m' # Cyan
BBlue='\033[1;34m'
BYellow='\033[1;33m' # Yellow
BRed='\033[1;31m'    # Red
BWhite='\033[1;37m'  # White

function AlterMenu {

    clear
    echo -e "${BBlue}\n\t\t\t\t\t=======================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t|${NC} ${BGreen}You are Connected to ${BRed}($current_db)${NC} ${BGreen}Database${NC}${BBlue} |${NC}"
    echo -e "${BBlue}\t\t\t\t\t=======================================${NC}\n"
    echo -e "${BBlue}\n\t\t\t\t\t\t=========================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC} ${BGreen}Alter Table Menu${NC}${BBlue} |${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t=========================${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t1)${NC}${BWhite} Add Column${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t2)${NC}${BWhite} Drop Column${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t3)${NC}${BWhite} Drop Constraint${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t4)${NC}${BWhite} Rename Column${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t5)${NC}${BWhite} Back${NC}\n"
    echo -e "${BYellow}\t\t\t\t\t\t=> Enter Your Choice:${NC} \c "
    read char

    case $char in
    1)
        clear

        source DBMS_Scripts/add_col.sh
        ;;

    2)
        clear
        source DBMS_Scripts/drop_col.sh

        ;;

    3)
        clear
        source DBMS_Scripts/drop_constrain.sh
        ;;

    4)
        clear
        source DBMS_Scripts/rename_col.sh
        ;;

    5)
        clear
        source DBMS_Scripts/exit.sh
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Back To Table Control Menu${NC}👇   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t Press any Key......${NC}\c"
        read press
        clear
        Table_Menu
        ;;

    *)
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=========================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}    ${BRed}Wrorng Choice${NC} 🥱 👎  ${BBlue}|"
        echo -e "${BBlue}\t\t\t\t\t\t=========================\n\n${NC}"
        echo -e "${BYellow}\t\t\t\t\t Press any Key to go back to Menu......${NC}\c"
        read press
        clear
        AlterMenu
        echo -e "\t\t\t==============================="
        ;;
    esac

}

function Table_Menu {
    clear
    current_db=$(cat "db_root/current_db")
    echo -e "${BBlue}\n\t\t\t\t\t=======================================${NC}"
    echo -e "${BBlue}\t\t\t\t\t|${NC} ${BGreen}You are Connected to ${BRed}($current_db)${NC} ${BGreen}Database${NC}${BBlue} |${NC}"
    echo -e "${BBlue}\t\t\t\t\t=======================================${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t======================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC} ${BGreen}Tables Control Menu${NC}${BBlue} |${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t======================${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t1)${NC}${BWhite} Create Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t2)${NC}${BWhite} Show Tables${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t3)${NC}${BWhite} Alter Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t4)${NC}${BWhite} Drop Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t5)${NC}${BWhite} Insert Into Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t6)${NC}${BWhite} Update Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t7)${NC}${BWhite} Delete From Table ${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t8)${NC}${BWhite} Select From Table${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t9)${NC}${BWhite} Show Columns${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t10)${NC}${BWhite} Disconnect From Current DataBase${NC}\n"
    echo -e "${BYellow}\t\t\t\t\t\t=> Enter Your Choice:${NC} \c "
    read char

    case $char in
    1)
        clear
        source DBMS_Scripts/create_table.sh
        ;;

    2)
        clear
        source DBMS_Scripts/show_tables.sh
        ;;

    3)
        clear
        AlterMenu
        ;;

    4)
        clear
        source DBMS_Scripts/drop_table.sh
        ;;
    5)
        clear
        source DBMS_Scripts/insert_into_table.sh
        ;;
    6)
        clear
        source DBMS_Scripts/update_table.sh
        ;;
    7)
        clear
        source DBMS_Scripts/delete.sh
        ;;
    8)
        clear
        source DBMS_Scripts/select.sh
        ;;
    9)
        clear
        source DBMS_Scripts/show_col.sh
        ;;

    10)
        clear
        source DBMS_Scripts/exit_db.sh
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t==============================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}Back To Main Menu${NC}👇   ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t==============================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t Press any Key......${NC}\c"
        read press
        clear
        mainMenu
        ;;
    *)
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=========================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}    ${BRed}Wrorng Choice${NC} 🥱  👎  ${BBlue}|"
        echo -e "${BBlue}\t\t\t\t\t\t=========================\n\n${NC}"
        echo -e "${BYellow}\t\t\t\t\t Press any Key to go back to Menu......${NC}\c"
        read press
        clear
        Table_Menu
        echo -e "\t\t\t==============================="
        ;;
    esac

}

function mainMenu {

    clear
    echo -e "${BBlue}\n\t\t\t\t\t\t=========================${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t|${NC} ${BGreen}DBMS With Bash Script${NC}${BBlue} |${NC}"
    echo -e "${BBlue}\t\t\t\t\t\t=========================${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t1)${NC}${BWhite} Create Database${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t2)${NC}${BWhite} List Databases${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t3)${NC}${BWhite} Connect To Database${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t4)${NC}${BWhite} Rename Database${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t5)${NC}${BWhite} Drop Database${NC}\n"
    echo -e "${BBlue}\t\t\t\t\t\t6)${NC}${BWhite} Exit${NC}\n"
    echo -e "${BYellow}\t\t\t\t\t\t=> Enter Your Choice:${NC} \c "
    read char

    case $char in
    1)
        clear

        source DBMS_Scripts/create_db.sh
        ;;

    2)
        clear
        source DBMS_Scripts/show_db.sh

        ;;

    3)
        clear
        source DBMS_Scripts/connect_db.sh
        ;;

    4)
        clear
        source DBMS_Scripts/rename_db.sh
        ;;

    5)
        clear
        source DBMS_Scripts/drop_db.sh
        ;;

    6)
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=========================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}      ${BWhite}SEE SOON${NC}  😉     ${BBlue}|${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t=========================${NC}\n\n"
        echo -e "${BYellow}\t\t\t\t\t\t Press any Key......${NC}\c"
        read press
        clear
        exit
        ;;
    *)
        clear
        echo -e "${BBlue}\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t=========================${NC}"
        echo -e "${BBlue}\t\t\t\t\t\t|${NC}    ${BRed}Wrorng Choice${NC} 🥱 👎  ${BBlue}|"
        echo -e "${BBlue}\t\t\t\t\t\t=========================\n\n${NC}"
        echo -e "${BYellow}\t\t\t\t\t Press any Key to go back to Menu......${NC}\c"
        read press
        clear
        mainMenu
        echo -e "\t\t\t==============================="
        ;;
    esac

}

mainMenu
