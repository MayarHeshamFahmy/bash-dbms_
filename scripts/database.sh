#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"

case $1 in
    create)
        read -p "Enter Database Name: " dbname

        # Validation: Must start with a letter OR "_" followed by a letter, be at least 3 chars, and contain only letters, numbers, and _
        if [[ ! "$dbname" =~ ^([a-zA-Z]|_[a-zA-Z])[a-zA-Z0-9_]{2,}$ ]]; then
            echo "Error: Database name must start with a letter OR '_' followed by a letter and be at least 3 characters long."
            echo "It cannot start with a number, contain spaces, '-', or special characters."
            exit 1
        fi

        if [[ -d "$DB_DIR/$dbname" ]]; then
            echo "Database already Exists."
        else
            mkdir -p "$DB_DIR/$dbname"
            echo "Database '$dbname' created successfully."
        fi
        ;;
      
    list)
        if [[ "$(ls -A "$DB_DIR" 2>/dev/null)" ]]; then
            ls "$DB_DIR" | awk '{print NR, $0}'
        else 
            echo "No Database Found."
        fi
        ;;
          
    connect)
        read -p "Enter database name to connect: " dbname
        if [[ -d "$DB_DIR/$dbname" ]]; then
            echo "Connected to database '$dbname'."
            "$BASE_DIR/scripts/connect.sh" "$dbname"
        else
            echo "Database doesn't Exist."
        fi 
        ;;
         
    drop)
        read -p "Enter database name to Drop: " dbname
        if [[ -d "$DB_DIR/$dbname" ]]; then
            rm -rf "$DB_DIR/$dbname"  # Force remove all contents
            if [[ ! -d "$DB_DIR/$dbname" ]]; then
                echo "Database '$dbname' deleted successfully."
            else
                echo "Error: Failed to delete database '$dbname'."
            fi
        else
            echo "Error: Database doesn't exist."
        fi
        ;;
         
    *)
        echo "Invalid database operation."
        ;;
esac 