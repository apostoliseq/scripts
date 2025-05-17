#!/bin/bash

# Ask the user for a file
echo "Please enter the path to your Spotify library file (press Enter for default 'My Spotify Library.txt'): "
read file_path

# Set default path if user just pressed Enter
if [ -z "$file_path" ]; then
    file_path="My Spotify Library.txt"
    echo "Using default file: $file_path"
fi

# Check if file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File '$file_path' not found."
    exit 1
fi

# Get current date in YYYYMMDD format
current_date=$(date +"%Y%m%d")

# Ask the user for output file name
echo "Please enter a name for the output file (without extension): "
read output_name

# Set default output name if user just pressed Enter
if [ -z "$output_name" ]; then
    # Create the default output file name based on input file
    filename=$(basename "$file_path")
    output_name="${filename%.*}_reversed"
    echo "Using default output name: $output_name"
fi

# Create the final output file name with date
output_file="${output_name}_${current_date}.txt"

# Create a temporary file with each song on its own line
temp_file=$(mktemp)
grep -v "^$" "$file_path" > "$temp_file"

# Create the reversed file and add line numbers
nl -s') ' -w1 < <(tac "$temp_file") > "$output_file"

# Remove trailing newline
truncate -s -1 "$output_file"

# Clean up temporary file
rm "$temp_file"

# Move file
mv $output_file "/mnt/d/7._Music/$output_file"

# Display completion message
echo "Reversed and numbered list has been saved to: $output_file"
