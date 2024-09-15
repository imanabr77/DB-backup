#!/bin/bash

# Function to print usage information
print_usage() {
    echo "Usage: $0 [-h] [-c <container_name>] [-u <username>] [-p <password>] [-d <database_name>] [-o <output_file>]"
    echo "Options:"
    echo "  -h           Show this help message"
    echo "  -c <name>     MySQL container name"
    echo "  -u <username> MySQL username"
    echo "  -p <password> MySQL password"
    echo "  -d <name>     Database name"
    echo "  -o <file>     Output file path"
}

# Check if help option is provided
if [[ "$#" -eq 0 || "$1" == "-h" ]]; then
    print_usage
    exit 0
fi

# Parse arguments
while [[ "$#" -gt 0 ]]
do
    case $1 in
        -c)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        -u)
            MYSQL_USER="$2"
            shift 2
            ;;
        -p)
            MYSQL_PASSWORD="$2"
            shift 2
            ;;
        -d)
            DB_NAME="$2"
            shift 2
            ;;
        -o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Set default values
CONTAINER_NAME=${CONTAINER_NAME:-mysql_container_name}
DB_NAME=${DB_NAME:-your_database_name}
OUTPUT_FILE=${OUTPUT_FILE:-$(date +%Y%m%d_%H%M%S)_dump.sql}

# Perform MySQL dump
echo "Performing MySQL dump..."
docker exec $CONTAINER_NAME /usr/bin/mysqldump -u $MYSQL_USER --password=$MYSQL_PASSWORD $DB_NAME > $OUTPUT_FILE

# Check if the command was successful
if [ $? -ne 0 ]; then
    echo "MySQL dump failed. Please check your credentials and database name."
    exit 1
else
    echo "MySQL dump completed successfully. Backup saved to $OUTPUT_FILE"
fi
