#!/bin/bash

# Script to generate usernames from a CSV file.
# Format: FFLL-XXX-M (First two of first name, first two of last name, class number, M for Marine)

# Check for input
if [[ $# -eq 0 ]]; then
    echo "Error: No input file specified."
    echo "Usage: $0 <path_to_csv_file>"
    exit 1
fi

input_file="$1"

if [[ ! -f "$input_file" ]]; then
    echo "Error: File not found at '$input_file'"
    exit 1
fi

# Prompt for class number
read -p "Enter the three-digit class number (e.g., 022): " class_number

if [[ -z "$class_number" ]]; then
    echo "Error: Class number cannot be empty."
    exit 1
fi

# Read from CSV and construct usernames
echo "---"

while IFS=',' read -r firstname lastname
do
    if [[ -z "$firstname" || -z "$lastname" ]]; then
        continue
    fi

    # Get the first two letters of the first name
    ff_sub=${firstname:0:2}
    # Convert them to uppercase using tr
    ff=$(echo "$ff_sub" | tr '[:lower:]' '[:upper:]')

    # Get the first two letters of the last name
    ll_sub=${lastname:0:2}
    # Convert them to uppercase using tr
    ll=$(echo "$ll_sub" | tr '[:lower:]' '[:upper:]')

    # Construct the final username
    echo "${ff}${ll}-${class_number}-M"

done < "$input_file"

# Print static XTRA usernames for backup and demo ranges
for i in {1..5}
do
    echo "XTRA${i}-${class_number}-M"
done