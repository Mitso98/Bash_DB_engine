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
    declare -i counter=1
    declare -a col_names
    declare -a col_dt
####### law mafe4 pk #################
    declare -i pk_index=1
    declare -a updated
    declare -i index
    declare -a col_index_to_change

################## Get column names & column data tyoes #################
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


	
            echo "Select Condition for Update on table $table_name: "
            
			PS3="Enter your Choice >"
            choices=("Update table with PK" "Update With Choosen Column")
############################# pk or column #################################################################
            select Choice in "${choices[@]}"                
                do
                case $Choice in
############################################## pk ##########################################################
                    "${choices[0]}" ) 

                        echo -e "Update $table_name where "${col_names[$pk_index]}" (pk): \c"
                            read -r old_pk
                            flg=0
                            ##cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index | sed  '1,2d'
                            for x in `cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index| sed '1,2d' `
                                do
                                    if [ "$old_pk" = "$x" ]
                                    then 
                                    
                                        flg=1
                                        break       
                                    fi	
                                done                           
                            if [ "$flg" = "0" ]
                            then 
                             echo "this value does not exisets"
                             exit 1
                            fi

                            PS3="Choose your Option>"
                            options=("Update Values of All Columns" "Update Values of Specific Columns")
########################################### ALL OR Specific ##########################################                           
                            select var in "${options[@]}"
                                do
                                    case $var in
############################################################### update all values ################################################
                                        "${options[0]}" ) 
                                                
                                                                  
############################################### Change Pk Value Or Not ########################################################33
                                                    echo "you want to update "${col_names[$pk_index]}"?"
                                                    PS3="Enter your Choice >"
                                                    
                                                    select Choice in "yes" "no"
                                                        do
                                                            case $Choice in
 ############################################################# yes ########################################################################                                                            
                                                                    yes ) 
                                                                    echo -e "Enter new "${col_names[$pk_index]}"(pk): \c"
                                                                    read -r new_pk
                                                                    if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                    then
                                                                        echo "PLease enter valid data"
                                                                    fi

 	                                                            	for x in "`(awk '{if(NR!=1 || NR!=2){print}}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index)`"
	                                                                    	do
	                                                                    		if [[ "$new_pk" == "$x" ]]
	                                                                                then
			                                                                        echo "PK must be unique"
                                                                                    exit 1
                                                                                fi
                                                                            done
                                                                            col_index_to_change[$pk_index]=$pk_index
                                                                            updated[$pk_index]=$new_pk
                                                                            break;;
################################################################  NO ################################################################333                                                                    
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
                                                                        echo -e "Enter New value of "$col"  : \c" 
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
                                                            echo "you want to update "${col_names[$index]}"?"
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
                                                           
                                                                    echo -e "Enter new "${col_names[$pk_index]}"(pk): \c"
                                                                    read -r new_pk
                                                                    if ! [[ ${col_dt[$pk_index]} == *"int"* && $new_pk =~ ^-?[0-9]+$ ]] || [[ ${col_dt[$pk_index]} == *"str"* && $new_pk =~ ^[A-Za-z].* ]]
                                                                    then
                                                                        echo "PLease enter valid data"
                                                                    fi

 	                                                        for x in "`(awk '{if(NR!=1 || NR!=2){print}}' "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index)`"
	                                                            do
	                                                                if [[ "$new_pk" == "$x" ]]
	                                                                    then
			                                                                echo "PK must be unique"
                                                                            exit 1
                                                                            fi
                                                            done
                                                            col_index_to_change[$pk_index]=$pk_index
                                                            updated[$pk_index]=$new_pk
                                                           
                                                            else
                                                                echo -e "Enter New value of "$col"  : \c" 
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
                           
                                     for x in "${col_index_to_change[@]}"
                                        do	
                                        echo -e "${updated[$x]}\c"
                                        done
                                
                                    echo ""

                    break;;
########################### cond column ############################################     
                    "${choices[1]}" )

                    echo -e "Enter where condition Column you want To update table ($table_name) for : \c"
                    read -r col_cond
                    	flg=0
                    declare -i col_inx=1
                        for col in "${col_names[@]}"
			            do	
				         if [ "$col_cond" = "$col" ]
                            then
                            flg=1
                            break
                            fi
                        col_inx=$col_inx+1
			            done
                    if [ $flg = 0]
                    then
                    echo "Not Found !!"
                    exit 1
                    fi


                    echo -e "Update ($table_name) where ("${col_names[$pk_index]}") (pk): \c"
                            read -r old_pk
                                             
                            for x in "`cat "$DB_PATH/$current_db/$table_name" | cut -d '|' -f $pk_index`"
                                do
                                    if [ "$x" != "$old_pk" ]
                                        then 
                                            echo "this value does not exisets"
                                                exit 1
                                    fi	
                                done      
                        PS3="Choose your Option>"
                        options=("Update Values of All Columns" "Update Values of Specific Columns")
                        select var in "${options[@]}"
                            do
                                case $var in
                                    "${options[0]}" ) 
                            
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                     break;;
                                    "${options[1]}" )
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                      break;;
                                    * ) echo "Wrong Choice" ;;
                                esac
                            done
                            
                            
                            
                            
                            
                            
                            
                                
                                
                                
                                echo "2" ;break;;                
                            * ) echo "Wrong Choice" ;;
                    esac
                done



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


          