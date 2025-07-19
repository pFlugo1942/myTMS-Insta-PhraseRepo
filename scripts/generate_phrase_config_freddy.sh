#!/bin/bash

# Specify the base directory
base_dir="./instashopper-android/shared"

# Initialize the configuration file
echo "phrase:" > ./phrase_config.yml
echo "  project_id: 15d32bafd4ffe92f156bcca0549a07e6" >> ./phrase_config.yml
echo "  file_format: xml" >> ./phrase_config.yml
echo "  push:" >> ./phrase_config.yml

# Initialize an ID counter for unique identifiers
counter=1

# Loop over all JSON files in nested directories
find "$base_dir" -type f -name "*.xml" | while read -r file_path; do
    # Get the full folder path
    folder_path=$(dirname "$file_path")
    
    # Get the file name
    file_name=$(basename "$file_path")
    
    # Get the folder name (the last directory in the path)
    folder_name=$(basename "$folder_path")

    # Generate a unique identifier for this folder (using the counter)
    unique_id="folder_$counter"
    
    # Increment the counter
    ((counter++))
    # Add the dynamic push configuration to the YAML file for non-locale folders
    echo "    - file: $folder_path/$file_name" >> ./phrase_config.yml
    echo "      params:" >> ./phrase_config.yml
    echo "        file_format: xml" >> ./phrase_config.yml
    echo "        locale_id: en" >> ./phrase_config.yml
    echo "        update_translations: true" >> ./phrase_config.yml
    echo "        tags: $folder_name" >> ./phrase_config.yml
    echo "        unique_id: $unique_id" >> ./phrase_config.yml
    echo "----------------------"
done
