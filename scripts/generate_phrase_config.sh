#!/bin/bash

# Specify the base directory
base_dir="./src"

# Initialize the configuration file
echo "phrase:" > ./push_config.yml
echo "  project_id: aa17ae5c0c19b1bd0d3cbe9e779d210a" >> ./push_config.yml
echo "  file_format: simple_json" >> ./push_config.yml
echo "  push:" >> ./push_config.yml

# Loop over all JSON files in nested directories
find "$base_dir" -type f -name "*.json" | while read -r file_path; do
    # Get the full folder path
    folder_path=$(dirname "$file_path")
    
    # Get the file name
    file_name=$(basename "$file_path")
    
    # Get the folder name (the last directory in the path)
    folder_name=$(basename "$folder_path")

    # Check if the folder path contains a locale code (e.g., "en", "fr", "en-US", "fr-CA")
    if [[ "$folder_path" =~ /[a-z]{2}(-[a-z]{2})?/ ]]; then
        # If the folder path contains a locale code, skip this file
        echo "Skipping file: $file_path (locale code detected)"
        continue
    fi

    # Add the dynamic push configuration to the YAML file for non-locale folders
    echo "    - file: $folder_path/$file_name" >> ./push_config.yml
    echo "      params:" >> ./push_config.yml
    echo "        file_format: simple_json" >> ./push_config.yml
    echo "        locale_id: 5efbe7aea90b7ea769ea0d008e3b77b0" >> ./push_config.yml
    echo "        update_translations: true" >> ./push_config.yml
    echo "        tags: $folder_name" >> ./push_config.yml
    echo "----------------------"
done
