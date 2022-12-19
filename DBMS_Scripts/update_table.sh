#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

    declare table_name
    current_db=`cat "$DB_PATH/current_db"`

    if [ -z $current_db ]
    then
        echo "You are not connected to DB"
        exit 1
    fi


    # get table name
    echo -e "Enter table name : \c"
    read -r table_name

    while [ ! -f "$DB_PATH/$current_db/$table_name" ]
    do
        echo "your table name is not exited"
        echo -e "Enter table name : \c"
        read -r table_name

    done


    declare -i Col_Num=`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name" | grep -o "|" | wc -l`
    declare -i Num_records=`awk '{print}' "$DB_PATH/$current_db/$table_name" | sed '1,2d' | wc -l`
    declare -i counter=1
    declare -a col_names
    declare -a col_dt
####### law mafe4 pk #################
    declare -i pk_index=1
    declare -a updated
    declare -i index
    declare -a col_index_to_change          
     declare -i col_index
################## Get column names & column data tyoes #################
    declare col_cond
    ##declare old_pk
    
    while [ $counter -le $Col_Num ]
        do
        type=`awk 'NR==1{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`
        col_name="`awk 'NR==2{print}' "$DB_PATH/$current_db/$table_name"  | cut -d '|' -f $counter`"
        col_names[$counter]=$col_name
        col_dt[$counter]=$type

        counter=$counter+1
    done 


######### get pk index ###############
	for col in ${Columns_dt[@]}
	    do	
		    if [[ $col = *":pk"* ]] 
			    then 
                break 
                fi
            pk_index=$pk_index+1        
		done
        


   for col in ${col_dt[@]}
			do	
				
				echo -e "$col |\c"
					
			done

            echo "" 

	for col in "${col_names[@]}"
			do	
				echo -e "$col |\c"
					
			done
            echo ""


	
            echo "Select Condition for Update on table ($table_name): "
            
			PS3="Enter your Choice >"
            choices=("Update table with PK" "Update With Choosen Column")
############################# pk or column #################################################################
            select Choice in "${choices[@]}"                
                do
                case $Choice in
############################################## pk ##########################################################
                    "${choices[0]}" ) 
                        col_index=$pk_index
                        echo -e "Update $table_name where ("${col_names[$pk_index]}")("${col_dt[$pk_index]}")(pk): \c"
                            read -r col_cond
                            flg=0

                         declare -i i=1
                         while [ $i -le $Num_records ] 
                            do
                             x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                               #echo $x
                                if [ "$x" = "$col_cond" ]
                                        then 
                                            flg=1
                                            break   
                                        fi	
                                    i=$i+1
                                 done 
                                             
                            if [ "$flg" = "0" ]
                            then 
                             echo "this value does not exisets"
                             exit 1
                            fi

                            PS3="Choose your Option >"
                            options=("Update Values of All Columns" "Update Values of Specific Columns")
########################################### ALL OR Specific ##########################################                           
                            select var in "${options[@]}"
                                do
                                    case $var in
############################################################### update all values ################################################
                                        "${options[0]}" ) 
                                                
                                                                  
############################################### Change Pk Value Or Not ########################################################33
                                                    echo "you want to update ("${col_names[$pk_index]}")?"
                                                    PS3="Enter your Choice >"
                                                    
                                                    select Choice in "yes" "no"
                                                        do
                                                            case $Choice in
 ############################################################# yes ########################################################################                                                            
                                                                    yes ) 
                                                                    echo -e "Enter new ("${col_names[$pk_index]}")("${col_dt[$pk_index]}")(pk): \c"
                                                                    read -r new_pk
                                                                    if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                    then
                                                                        echo "PLease enter valid data"
                                                                        exit 1

                                                                    fi

 	                                                            	
                                                                    declare -i i=1
                                                                    while [ $i -le $Num_records ] 
                                                                        do
                                                                        x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                                                                            if [ "$x" = "$new_pk" ]
                                                                                then 
                                                                                    echo "PK must be unique"
                                                                                        exit 1
                                                                            fi	
                                                                                i=$i+1
                                                                            done 
                                                                            col_index_to_change[$pk_index]=$pk_index
                                                                            updated[$pk_index]=$new_pk
                                                                            break;;
################################################################ NO ################################################################333                                                                    
                                                                    no ) break;;
                                                                    * ) echo "Wrong Choice" ;;
                                                    
                                                            esac
                                                        done
############################################################## updated Data ####################################################                                                        
                                                    index=1
                                                    for col in "${col_names[@]}"
                                                            do 
                                                            if [ "$index" != "$pk_index" ]
                                                                then
                                                                        echo -e "Enter New value of ("$col")("${col_dt[$index]}"): \c" 
                                                                        read -r data  
                                                                        # check for integer
                                                                        if [[ ${col_dt[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]
                                                                        then 
                                                                            updated[$index]="$data"
                                                                        #check for string     
                                                                        elif [[ ${col_dt[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]
                                                                            then
                                                                                updated[$index]="$data"
                                                                        #check for it null 
                                                                        elif [ -z $data ]
                                                                            then
                                                                                updated[$index]="$data"
                                                                        else
                                                                            echo "PLease enter valid data"
                                                                            exit 1
                                                                        fi	
                                                                    col_index_to_change[$index]=$index
                                                                fi
                                                                
                                                                    index=$index+1
                                                                    done 

                                                        break;;
####################################### change specfic columns ################################
                                        "${options[1]}" )
                                            index=1
                                                for col in "${col_names[@]}"
                                                            do 
                                                            echo "you want to update ("${col_names[$index]}")?"
                                                            PS3="Enter your Choice >"
                                                            flag=0
                                                            select Choice in "yes" "no"
                                                                do
                                                                    case $Choice in
                                                                    yes ) flag=1
                                                                    break;;
                                                                    no ) break;;
                                                                    * ) echo "Wrong Choice" ;;
                                                                    esac
                                                                done
                                                    if [ "$flag" = "1" ]
                                                    then 
                                                        if [ "$index" = "$pk_index" ]
                                                            then
                                                           
                                                                    echo -e "Enter new ("${col_names[$pk_index]}") ("${col_dt[$pk_index]}")(pk): \c"
                                                                    read -r new_pk
                                                                    if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                    then
                                                                        echo "PLease enter valid data"
                                                                    fi

                                                                declare -i i=1
                                                               while [ $i -le $Num_records ] 
                                                                    do
                                                                        x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                                                                        if [ "$x" = "$new_pk" ]
                                                                            then 
                                                                            echo "PK must be unique"
                                                                            exit 1
                                                                        fi	
                                                                     i=$i+1
                                                                 done 
                                                            col_index_to_change[$pk_index]=$pk_index
                                                            updated[$pk_index]=$new_pk
                                                           
                                                            else
                                                                echo -e "Enter New value of ("$col")("${col_dt[$index]}") : \c" 
                                                                read -r data  
                                                                    # check for integer
                                                                    if [[ ${col_dt[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]
                                                                        then 
                                                                            updated[$index]="$data"
                                                                    #check for string     
                                                                    elif [[ ${col_dt[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]
                                                                        then
                                                                            updated[$index]="$data"
                                                                    #check for it null 
                                                                    elif [ -z $data ]
                                                                        then
                                                                            updated[$index]="$data"
                                                                    else
                                                                        echo "PLease enter valid data"
                                                                        exit 1
                                                                    fi	
                                                                col_index_to_change[$index]=$index
                                                        fi

                                                    fi
                                                index=$index+1
                                                done                                        
                                        break;;
                                        
########################################## add updated data to right place #############################                                       
                                        
                                        * ) echo "Wrong Choice" ;;
                                    esac
                                done
                           
                    break;;
########################### cond column ############################################     
                    "${choices[1]}" )

                    echo -e "Enter where condition Column you want To update table ($table_name) for : \c"
                    read -r col_cond
                    flg=0
                     col_index=1
                        for col in "${col_names[@]}"
			            do	
				         if [ "$col_cond" = "$col" ]
                            then
                            flg=1
                            break
                            fi
                            col_index=$col_index+1
			            done
                        if [ $flg = 0 ]
                            then
                            echo "Not Found !!"
                            exit 1
                        fi
                        
                        echo -e "Update ($table_name) where ("${col_names[$col_index]}") ("${col_dt[$col_index]}"): \c"
                        read -r data                                
                        flg=0
                        declare -i i=1
                        while [ $i -le $Num_records ] 
                                do
                                    x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $col_index | sed '1,2d'|sed "${i}p;d" `
                                    if [ "$x" = "$data" ]
                                    then 
                                    flg=1
                                    break
                                    fi	
                                    i=$i+1
                                done  
                               
                                if [ $flg = 0 ]
                                then
                                    echo "this value does not exisets"
                                    exit 1
                                fi
                
                        PS3="Choose your Option>"
                        options=("Update Values of All Columns" "Update Values of Specific Columns")
                        select var in "${options[@]}"
                            do
                                case $var in

                                    "${options[0]}" ) 
                            
                                                    index=1
                                                    for col in "${col_names[@]}"
                                                            do 
                                                            if [ "$index" != "$pk_index" ]
                                                                then
                                                                        echo -e "Enter New value of ("$col") ("${col_dt[$index]}") : \c" 
                                                                        read -r data  
                                                                        # check for integer
                                                                        if [[ ${col_dt[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]
                                                                        then 
                                                                            updated[$index]="$data"
                                                                        #check for string     
                                                                        elif [[ ${col_dt[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]
                                                                            then
                                                                                updated[$index]="$data"
                                                                        #check for it null 
                                                                        elif [ -z $data ]
                                                                            then
                                                                                updated[$index]="$data"
                                                                        else
                                                                            echo "PLease enter valid data"
                                                                            exit 1
                                                                        fi	
                                                                        col_index_to_change[$index]=$index

                                                            else 
                                                                echo -e "Enter new ("${col_names[$pk_index]}")("${col_dt[$pk_index]}")(pk): \c"
                                                                 read -r new_pk
                                                                        if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                            then
                                                                                echo "PLease enter valid data"
                                                                                exit 1
                                                                            fi
                                                              declare -i i=1
                                                               while [ $i -le $Num_records ] 
                                                                    do
                                                                        x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                                                                        if [ "$x" = "$new_pk" ]
                                                                            then 
                                                                            echo "PK must be unique"
                                                                            exit 1
                                                                        fi	
                                                                     i=$i+1
                                                                 done 


                                                                        col_index_to_change[$pk_index]=$pk_index
                                                                        updated[$pk_index]=$new_pk                                                              


                                                                  
                                                                    fi
                                                                
                                                                    index=$index+1
                                                                    done 
                                
                                        break;;

                                    "${options[1]}" )
                                    
                                                index=1
                                                for col in "${col_names[@]}"
                                                            do 
                                                            echo "you want to update ("${col_names[$index]}")?"
                                                            PS3="Enter your Choice >"
                                                            flag=0
                                                            select Choice in "yes" "no"
                                                                do
                                                                    case $Choice in
                                                                    yes ) flag=1
                                                                    break;;
                                                                    no ) break;;
                                                                    * ) echo "Wrong Choice" ;;
                                                                    esac
                                                                done
                                                    if [ "$flag" = "1" ]
                                                    then 
                                                        if [ "$index" = "$pk_index" ]
                                                            then
                                                           
                                                                    echo -e "Enter new ("${col_names[$pk_index]}") ("${col_dt[$pk_index]}")(pk): \c"
                                                                    read -r new_pk
                                                                    if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                    then
                                                                        echo "PLease enter valid data"
                                                                        exit 1
                                                                    fi

 	                                                        
                                                                    declare -i i=1
                                                                    while [ $i -le $Num_records ] 
                                                                    do
                                                                        x=`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed '1,2d'|sed "${i}p;d" `
                                                                        
                                                                        if [ "$x" = "$new_pk" ]
                                                                            then 
                                                                            echo "PK must be unique"
                                                                            exit 1
                                                                        fi	
                                                                     i=$i+1
                                                                 done 

                                                            col_index_to_change[$pk_index]=$pk_index
                                                            updated[$pk_index]=$new_pk
                                                           
                                                            else
                                                                echo -e "Enter New value of ("$col") ("${col_dt[$index]}")  : \c" 
                                                                read -r data  
                                                                    # check for integer
                                                                    if [[ ${col_dt[$index]} == *"int"* && $data =~ ^-?[0-9]+$ ]]
                                                                        then 
                                                                            updated[$index]="$data"
                                                                    #check for string     
                                                                    elif [[ ${col_dt[$index]} == *"str"* && $data =~ ^[A-Za-z].* ]]
                                                                        then
                                                                            updated[$index]="$data"
                                                                    #check for it null 
                                                                    elif [ -z $data ]
                                                                        then
                                                                            updated[$index]="$data"
                                                                    else
                                                                        echo "PLease enter valid data"
                                                                        exit 1
                                                                    fi	
                                                                col_index_to_change[$index]=$index


                                                        fi

                                                    fi
                                                    index=$index+1
                                                done                        
                
                                             break;;

                                    * ) echo "Wrong Choice" ;;
                                esac
                            done
                            
                                            
                            break;; 


                        * ) echo "Wrong Choice" ;;
                    esac
                done
        

                for x in  "${col_index_to_change[@]}"
                do 

      
                echo -e "${updated[$x]}|\c"

                done

                echo ""




#select cond
#1- cond pk
#2- cond choose column 

# id name salary age  
# where id = ??

# update when pk eqaul :
#1- update all values 
#2- spacfic columns 

#want to update name ?
#yes
#no
#yes enter new value
#no  


#want to update salary ?
#yes
#no
#yes enter new value
#no   


#  update when any column eqaul :
#1- update all values 
#2- spacfic columns 


          