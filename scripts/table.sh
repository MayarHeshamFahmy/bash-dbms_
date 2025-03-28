#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"
dbname=$2

case $1 in 
    create)
        read -p "Enter Table Name: " tableName
        TABLE_PATH="$DB_DIR/$dbname/$tableName"

        # Ensure the database directory exists
        if [[ ! -d "$DB_DIR/$dbname" ]]; then
            echo "Error: Database '$dbname' does not exist."
            exit 1
        fi

        # Validation: Must start with a letter OR "_" followed by a letter, be at least 3 chars, and contain only letters, numbers, and _
        if [[ ! "$tableName" =~ ^([a-zA-Z]|_[a-zA-Z])[a-zA-Z0-9_]{2,}$ ]]; then
            echo "Error: Table name must start with a letter OR '_' followed by a letter and be at least 3 characters long."
            echo "It cannot start with a number, contain spaces, '-', or special characters."
            exit 1
        fi

        if [[ -f "$TABLE_PATH" ]]; then
            echo "Table already Exists."
        else
            touch "$TABLE_PATH"
            echo "Table '$tableName' Created."
        fi
        ;;
    
    list)
        if [[ -d "$DB_DIR/$dbname" && "$(ls -A "$DB_DIR/$dbname" 2>/dev/null)" ]]; then
            echo "Tables in $dbname: "
            ls "$DB_DIR/$dbname" | awk '{print NR, $0}'
        else
            echo "No Tables Found."
        fi
        ;;
    
    drop)
        read -p "Enter Table Name To Drop: " tableName
        TABLE_PATH="$DB_DIR/$dbname/$tableName"

        if [[ -f "$TABLE_PATH" ]]; then
            rm "$TABLE_PATH"
            echo "Table '$tableName' deleted."
        else
            echo "Table doesn't Exist."
        fi
        ;;
    
    *)
        echo "Invalid table operation."
        ;;
esac
