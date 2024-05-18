#!/bin/bash

# Define the base and build directories
BASE_DIR="./progs/gametypes"
BUILD_DIR="./archives"

# Create the build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Loop through each directory within the base directory
for dir in "$BASE_DIR"/*; do
  if [ -d "$dir" ]; then
    # Get the name of the directory
    dirname=$(basename "$dir")
    # Define the output file name
    output_file="$BUILD_DIR/$dirname.pk3"
    
    # Compress the contents of the directory into a pk3 archive
    7z a -tzip "$output_file" "$dir"/*

    # Check if the compression was successful
    if [ $? -eq 0 ]; then
      echo "Successfully compressed $dir into $output_file"
    else
      echo "Failed to compress $dir"
    fi
  fi
done
