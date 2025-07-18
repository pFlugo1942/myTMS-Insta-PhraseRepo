#!/bin/bash

# Iterate over all directories in the src folder and generate push/pull configurations with dynamic tags
for dir in ./instashopper-android/shared/*/; do
  folder_name=$(basename "$dir")
  
  # Check if the parent directory (and any directories in the path) contains a locale code (e.g., "en", "fr", "en-US", "fr-CA")
  if [[ "$dir" =~ /[a-z]{2}(-[a-z]{2})?/ ]]; then
    # If the directory contains a locale code, skip this folder
    echo "Skipping folder: $dir (locale code detected)"
    continue
  fi

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
