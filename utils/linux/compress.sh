#!/bin/bash

# Define the base, temporary, and archives directories
BASE_DIR="./progs/gametypes"
TEMP_DIR="./tmp"
ARCHIVES_DIR="./archives"

# Create the archives and temporary directories if they don't exist
mkdir -p "$ARCHIVES_DIR"
mkdir -p "$TEMP_DIR"

# Loop through each directory within the base directory
for dir in "$BASE_DIR"/*; do
  if [ -d "$dir" ]; then
    # Get the name of the directory
    dirname=$(basename "$dir")

    # Define the temporary directory for this folder
    temp_dir="$TEMP_DIR/$dirname"
    
    # Create the temporary directory
    mkdir -p "$temp_dir"

    # Copy the contents to the temporary directory
    cp -r "$dir"/* "$temp_dir"

    # Define the output file name
    output_file="$ARCHIVES_DIR/$dirname.pk3"
    
    # Compress the contents of the temporary directory into a pk3 archive
    7z a -tzip "$output_file" "$temp_dir"/*

    # Check if the compression was successful
    if [ $? -eq 0 ]; then
      echo "Successfully compressed $dir into $output_file"
    else
      echo "Failed to compress $dir"
    fi

    # Remove the temporary directory
    rm -rf "$temp_dir"
  fi
done
