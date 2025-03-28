#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"

dbname=$1

if [[ -z "$dbname" || ! -d "$DB_DIR/$dbname" ]]; then
   echo "Invalid Database Connection."
   exit 1
fi

while true; do
    echo "================================"
    echo " Connected to Database: $dbname "
    echo "================================"
    select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Row" "Back To Main Menu"; do
        case $REPLY in
            1) "$BASE_DIR/scripts/table.sh" create "$dbname"; break ;;
            2) "$BASE_DIR/scripts/table.sh" list "$dbname"; break ;;
            3) "$BASE_DIR/scripts/table.sh" drop "$dbname"; break ;;
            4) "$BASE_DIR/scripts/record.sh" insert "$dbname"; break ;;
            5) "$BASE_DIR/scripts/record.sh" select "$dbname"; break ;;
            6) "$BASE_DIR/scripts/record.sh" delete "$dbname"; break ;;
            7) "$BASE_DIR/scripts/record.sh" update "$dbname"; break ;;
            8) echo "Returning To Main Menu..."; exit 0 ;;
            *) echo "Invalid option. Please Enter another number."; ;;
        esac
    done
done
