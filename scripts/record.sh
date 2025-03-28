#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"
dbname=$2

case $1 in
    insert)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            while true; do
                read -p "Enter Record ID: " recordId

                # Ensure ID is a number
                if [[ ! "$recordId" =~ ^[0-9]+$ ]]; then
                    echo "Error: ID must be a number. Try again."
                    continue
                fi

                # Check if ID already exists
                if grep -q "^$recordId," "$tablePath"; then
                    echo "Error: ID $recordId already exists. Enter a different ID."
                else
                    break
                fi
            done

            read -p "Enter Name: " name
            read -p "Enter Age: " age

            # Insert new record
            echo "$recordId,$name,$age" >> "$tablePath"

            # Sort the table by ID (ascending order)
            sort -t, -k1,1n -o "$tablePath" "$tablePath"

            echo "Record inserted successfully."
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    select)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            echo "Records in Table '$tableName':"
            awk -F, '{print "ID:", $1, "| Name:", $2, "| Age:", $3}' "$tablePath"
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    delete)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            read -p "Enter Record ID to Delete: " recordId
            if grep -q "^$recordId," "$tablePath"; then
                grep -v "^$recordId," "$tablePath" > "$tablePath.tmp" && mv "$tablePath.tmp" "$tablePath"
                echo "Record with ID $recordId deleted successfully."
            else
                echo "Error: Record with ID $recordId not found."
            fi
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    update)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            read -p "Enter Record ID to Update: " recordId
            if grep -q "^$recordId," "$tablePath"; then
                read -p "Enter New Name: " name
                read -p "Enter New Age: " age
                awk -F, -v id="$recordId" -v newName="$name" -v newAge="$age" 'BEGIN { OFS = "," } { if ($1 == id) { $2 = newName; $3 = newAge } print }' "$tablePath" > "$tablePath.tmp" && mv "$tablePath.tmp" "$tablePath"
                echo "Record with ID $recordId updated successfully."
            else
                echo "Error: Record with ID $recordId not found."
            fi
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    *)
        echo "Invalid record operation."
        ;;
esac
