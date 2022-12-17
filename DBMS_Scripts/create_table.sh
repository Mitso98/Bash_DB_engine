#!/bin/bash

# IMPORT DB_PATH variable
source ./db_root_path.sh

declare table_name
declare -i ColNum
current_db=`cat "$DB_PATH/current_db"`

if [ -z $current_db ]
then
	echo "You are not connected to DB"
	exit 1
fi



if [ $# -eq 0 ]
then
	echo -e "Enter table name : \c"
	read -r table_name
fi

if ! [[ $table_name =~ ^[A-Za-z].* ]]
then 
	echo "PLease enter a valid name"
	exit 1
fi


# check if folder is empty do not excute below command
if [ "$(ls -A "$DB_PATH/$current_db")" ] 
then
	list_tables=`ls -d $DB_PATH/$current_db/* | cut -f4 -d '/' `
	for tables in $list_tables
	do	
		table_name_lower=$(echo "${table_name,,}")
		tables_lower=$(echo "${tables,,}")
		
		if [ "$tables_lower" = "$table_name_lower" ]
		then
			echo "This table already exists"
			exit 1
		fi


	done
fi

echo -e "ENTER Number of Colmns : \c"
read -r Col_Num


if [ "$Col_Num" = "0" ]
	then
	echo "Enter Number not zero!!"
	exit
	fi

if [[ ! "$Col_Num" =~ ^[0-9]+$ ]] 
then
	
    echo "Enter Vaild Number !!"
    exit
fi

declare -i counter=1
declare  col_type
declare -a Columns_dt
declare -a Columns_names
declare  col_name
declare  col_type

	while [ $counter -le $Col_Num ]
	do
		echo -e "Enter Name of Column $counter : \c " 

		read -r col_name
		
		if ! [[ "$col_name" =~ ^[A-Za-z].* ]]
		then 
			echo "PLease enter a valid name"
			exit 1
		fi

		for col in ${Columns_names[@]}
			do	
				col_name_lower=$(echo "${col_name,,}")
				col_lower=$(echo "${col,,}")
				
				if [ "$col_name_lower" = "$col_lower" ]
				then
					echo "This Column already existed"
					exit 1
				fi

			done




		echo "Type of Column $col_name: "
			PS3="Enter your Choice >"
			select type in "int" "str"
			do
				case $type in
				int ) col_type="int";break;;
				str ) col_type="str";break;;
				* ) echo "Wrong Choice" ;;
				esac
			done

			pk=0	
			for col in ${Columns_dt[@]}
				do	
					if [[ $col = *":pk"* ]] 
					then
						pk=1
						break
					fi
				done

		if [ $pk = 0 ]
		then

			echo "Make PrimaryKey ? "
			PS3="Enter your Choice >"
					select Choice in "yes" "no"
					do
						case $Choice in
						yes ) col_type="$col_type:pk";
						break;;
						no )break;;
						* ) echo "Wrong Choice" ;;
						esac
					done
		fi

		Columns_names[$counter]="$col_name"
		Columns_dt[$counter]="$col_type"

		counter=$counter+1
	done 	


	for col in ${Columns_dt[@]}
			do	
				if [[ $col = *":pk"* ]] 
				then
					pk=1
					break
				else
					pk=0
			
				fi
			done

		if [ $pk = 1 ]
			then 
				
				touch "$DB_PATH/$current_db/"$table_name""

				table_file="$DB_PATH/$current_db/"$table_name""
				
				for col in ${Columns_dt[@]}
				do
				printf ""$col"|">>"$table_file"
				done 
				printf "%s\n">>"$table_file"
				for col in "${Columns_names[@]}"
				do
				coll=`echo ""$col"|"`
				printf "$coll">>"$table_file"
				done
				printf "%s">>"$table_file"



				echo "The Table Created Successfuly :)"

		else
				echo "Your Table has not  PK Column :)"
		fi
