#!/bin/bash
BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"

while true; do
    echo "======================"
    echo " Bash Shell DBMS Menu "
    echo "======================"
    
    select choice in "Create Database" "List DataBase" "Connect to Database" "Drop Database" "Exit"; do
        case $REPLY in 
            1) "$BASE_DIR/scripts/database.sh" create;
               break
               ;;
            2) 
               if [ ! -d "$DB_DIR" ]; then
                   echo "No Database Found. Creating databases directory..."
                   mkdir -p "$DB_DIR"
               fi
               ls "$DB_DIR"
               break
               ;;
            3) "$BASE_DIR/scripts/database.sh" connect;
               break
               ;;
            4) "$BASE_DIR/scripts/database.sh" drop;
               break
               ;;
            5) echo "Exiting "; 
               exit 0
               ;;
            *) echo "Invalid option. Please enter a number from the menu."
               ;;
        esac
    done
done
