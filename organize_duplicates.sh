#!/bin/bash

# This script organizes duplicate files by file type from a source directory to a destination directory.
# Command to run this script : ./organize_duplicates.sh /path/to/source_directory /path/to/destination_directory

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Assign command-line arguments to variables
source_dir="$1"
destination_dir="$2"

# Ensure the destination directory exists
mkdir -p "$destination_dir"

# Find duplicate files in the source directory
fdupes -r "$source_dir" | while IFS= read -r file; do
    # Get the file type (extension) of the current file
    file_type=$(file --brief --mime-type "$file" | awk -F'/' '{print $2}')

    # Handle files without extensions
    if [ -z "$file_type" ]; then
        file_type="NoExtension"
    fi

    # Create subdirectory for the file type if it doesn't exist
    mkdir -p "$destination_dir/$file_type"

    # Move the duplicate file to the corresponding subdirectory
    mv "$file" "$destination_dir/$file_type"
done

echo "Duplicate files have been organized by file type in $destination_dir"
