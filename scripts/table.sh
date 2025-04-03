#!/bin/bash

BASE_DIR="/home/mayarheshamfahmy/Desktop/bash-dbms(1)/bash-dbms"
DB_DIR="$BASE_DIR/databases"
dbname=$2

validate_tablename() {
    local tablename="$1"
    if [[ ! $tablename =~ ^[A-Za-z_][A-Za-z0-9_]*$ || ${#tablename} -lt 3 ]]; then
        echo "Error: Table name must start with a letter or '_' and be at least 3 characters long."
        echo "It cannot start with a number, contain spaces, '-', or special characters."
        return 1
    fi
    return 0
}

case $1 in 
    create)
        read -p "Enter Table Name: " tableName
        validate_tablename "$tableName" || exit 1

        TABLE_PATH="$DB_DIR/$dbname/$tableName"
        METADATA_PATH="$TABLE_PATH.meta"

        if [[ ! -d "$DB_DIR/$dbname" ]]; then
            echo "Error: Database '$dbname' does not exist."
            exit 1
        fi

        if [[ -f "$TABLE_PATH" ]]; then
            echo "Table already exists."
        else
            read -p "Enter Number of Columns: " colNum
            if [[ ! "$colNum" =~ ^[1-9][0-9]*$ ]]; then
                echo "Error: Invalid number of columns."
                exit 1
            fi

            touch "$TABLE_PATH"
            echo "$tableName,$colNum" > "$METADATA_PATH"

            for ((i = 1; i <= colNum; i++)); do
                read -p "Enter Column $i Name: " colName
                read -p "Enter Data Type for $colName (int/str/float/date): " colType
                while [[ ! "$colType" =~ ^(int|str|float|date)$ ]]; do
                    echo "Invalid data type! Choose from (int, str, float, date)."
                    read -p "Enter Data Type for $colName: " colType
                done

                if [[ $i -eq 1 ]]; then
                    echo "$colName (Primary Key),$colType" >> "$METADATA_PATH"
                else
                    echo "$colName,$colType" >> "$METADATA_PATH"
                fi
            done

            echo "Table '$tableName' created with metadata."
        fi
        ;;
    
    list)
        if [[ -d "$DB_DIR/$dbname" && "$(ls -A "$DB_DIR/$dbname" 2>/dev/null)" ]]; then
            echo "Tables in $dbname:" 
            ls "$DB_DIR/$dbname" | grep -v ".meta" | awk '{print NR, $0}'
        else
            echo "No tables found."
        fi
        ;;
    
    drop)
        read -p "Enter Table Name To Drop: " tableName
        validate_tablename "$tableName" || exit 1

        TABLE_PATH="$DB_DIR/$dbname/$tableName"
        METADATA_PATH="$TABLE_PATH.meta"

        if [[ -f "$TABLE_PATH" ]]; then
            rm "$TABLE_PATH" "$METADATA_PATH"
            echo "Table '$tableName' deleted."
        else
            echo "Table doesn't exist."
        fi
        ;;
    
    *)
        echo "Invalid table operation."
        ;;
esac