#!/bin/bash

# Specify the base directory
base_dir="./instashopper-android/shared"

# Initialize the configuration file
echo "phrase:" > ./push_config.yml
echo "  project_id: 15d32bafd4ffe92f156bcca0549a07e6" >> ./push_config.yml
echo "  file_format: xml" >> ./push_config.yml
echo "  push:" >> ./push_config.yml

# Loop over all JSON files in nested directories
find "$base_dir" -type f -name "*.xml" | while read -r file_path; do
    # Get the full folder path
    folder_path=$(dirname "$file_path")
    
    # Get the file name
    file_name=$(basename "$file_path")
    
    # Get the folder name (the last directory in the path)
    folder_name=$(basename "$folder_path")

    # Add the dynamic push configuration to the YAML file for non-locale folders
    echo "    - file: $folder_path/$file_name" >> ./push_config.yml
    echo "      params:" >> ./push_config.yml
    echo "        file_format: xml" >> ./push_config.yml
    echo "        locale_id: en" >> ./push_config.yml
    echo "        update_translations: true" >> ./push_config.yml
    echo "        tags: $folder_name" >> ./push_config.yml
    echo "----------------------"

    # Append to pull configuration
    echo "    - file: $folder_path-<locale_code>/strings.xml" >> pull_config.yml
    echo "      params:" >> pull_config.yml
    echo "        file_format: xml" >> pull_config.yml
    echo "        tags: $folder_name" >> pull_config.yml

done
