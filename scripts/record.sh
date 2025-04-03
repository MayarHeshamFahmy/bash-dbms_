#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"
dbname=$2

case $1 in
    insert)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"
        metadataPath="$tablePath.meta"

        if [[ -f "$tablePath" ]]; then
            colNum=$(awk -F, 'NR==1 {print $2}' "$metadataPath")

            while true; do
                read -p "Enter Primary Key (ID): " primaryKey
                if [[ ! "$primaryKey" =~ ^[0-9]+$ ]]; then
                    echo "Error: Primary Key must be a number."
                    continue
                fi

                if grep -q "^$primaryKey," "$tablePath"; then
                    echo "Error: Primary Key already exists!"
                else
                    break
                fi
            done

            row="$primaryKey"
            for ((i = 2; i <= colNum; i++)); do
                colMeta=$(awk "NR==$((i+1))" "$metadataPath")
                colName=$(echo "$colMeta" | cut -d',' -f1)
                colType=$(echo "$colMeta" | cut -d',' -f2)

                while true; do
                    read -p "Enter $colName ($colType): " colValue

                    case $colType in
                        int)
                            if [[ ! "$colValue" =~ ^[0-9]+$ ]]; then
                                echo "Error: $colName must be an integer!"
                                continue
                            fi
                            ;;
                        float)
                            if [[ ! "$colValue" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                                echo "Error: $colName must be a float!"
                                continue
                            fi
                            ;;
                        str)
                            if [[ ! "$colValue" =~ ^[A-Za-z[:space:]]+$ ]]; then
                                echo "Error: $colName must contain only letters and spaces!"
                                continue
                            fi
                            ;;
                        date)
                            if [[ ! "$colValue" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                                echo "Error: $colName must be a date (YYYY-MM-DD)!"
                                continue
                            fi
                            if ! date -d "$colValue" "+%Y-%m-%d" >/dev/null 2>&1; then
                                echo "Error: Invalid date! Ensure format is YYYY-MM-DD and it's a real date."
                                continue
                            fi
                            ;;
                    esac
                    break
                done
                row="$row,$colValue"
            done

            echo "$row" >> "$tablePath"
            sort -t, -k1,1n -o "$tablePath" "$tablePath"

            echo "Record inserted successfully!"
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    select)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            if [[ ! -s "$tablePath" ]]; then
                echo "Table '$tableName' is empty."
            else
                echo "Records in Table '$tableName':"
                column -t -s, "$tablePath"
            fi
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    delete)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"

        if [[ -f "$tablePath" ]]; then
            read -p "Enter Primary Key to Delete: " primaryKey
            if grep -q "^$primaryKey," "$tablePath"; then
                grep -v "^$primaryKey," "$tablePath" > "$tablePath.tmp" && mv "$tablePath.tmp" "$tablePath"
                echo "Record with Primary Key $primaryKey deleted."
            else
                echo "Error: Record with Primary Key $primaryKey not found."
            fi
        else
            echo "Error: Table '$tableName' does not exist."
        fi
        ;;

    update)
        read -p "Enter Table Name: " tableName
        tablePath="$DB_DIR/$dbname/$tableName"
        metadataPath="$tablePath.meta"

        if [[ -f "$tablePath" ]]; then
            read -p "Enter Record ID to Update: " recordId
            if grep -q "^$recordId," "$tablePath"; then
                newRow="$recordId"
                for ((i = 2; i <= colNum; i++)); do
                    colMeta=$(awk "NR==$((i+1))" "$metadataPath")
                    colName=$(echo "$colMeta" | cut -d',' -f1)
                    colType=$(echo "$colMeta" | cut -d',' -f2)

                    while true; do
                        read -p "Enter new value for $colName ($colType): " colValue

                        case $colType in
                            int)
                                if [[ ! "$colValue" =~ ^[0-9]+$ ]]; then
                                    echo "Error: $colName must be an integer!"
                                    continue
                                fi
                                ;;
                            float)
                                if [[ ! "$colValue" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                                    echo "Error: $colName must be a float!"
                                    continue
                                fi
                                ;;
                            str)
                                if [[ ! "$colValue" =~ ^[A-Za-z[:space:]]+$ ]]; then
                                    echo "Error: $colName must contain only letters and spaces!"
                                    continue
                                fi
                                ;;
                            date)
                                if [[ ! "$colValue" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                                    echo "Error: $colName must be a date (YYYY-MM-DD)!"
                                    continue
                                fi
                                if ! date -d "$colValue" "+%Y-%m-%d" >/dev/null 2>&1; then
                                    echo "Error: Invalid date! Ensure format is YYYY-MM-DD and it's a real date."
                                    continue
                                fi
                                ;;
                        esac
                        break
                    done
                    newRow="$newRow,$colValue"
                done
                awk -F, -v id="$recordId" -v newRow="$newRow" 'BEGIN { OFS = "," } { if ($1 == id) print newRow; else print }' "$tablePath" > "$tablePath.tmp" && mv "$tablePath.tmp" "$tablePath"
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
