#!/bin/bash

# Iterate over all directories in the src folder and generate push/pull configurations with dynamic tags
for dir in ./instashopper-android/shared/*/; do
  folder_name=$(basename "$dir")
  
  # Append to push configuration
  echo "    - file: $dir/**/*.xml" >> push_config.yml
  echo "      params:" >> push_config.yml
  echo "        file_format: xml" >> push_config.yml
  echo "        locale_id: 15d32bafd4ffe92f156bcca0549a07e6" >> push_config.yml
  echo "        update_translations: true" >> push_config.yml
  echo "        tags: $folder_name" >> push_config.yml

  # Append to pull configuration
  echo "    - file: $dir/<locale_code>.xml" >> pull_config.yml
  echo "      params:" >> pull_config.yml
  echo "        file_format: xml" >> pull_config.yml
  echo "        tags: $folder_name" >> pull_config.yml
done
