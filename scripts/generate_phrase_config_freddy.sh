#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Set the root directory to search and output file name
ROOT_DIR="./instashopper-android/shared"
OUTPUT_FILE="new_push_config.yml"

# Define project ID (replace with your real one if needed)
PHRASE_PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

echo "🔧 Starting script..."
echo "🔍 Searching for .xml files under: $ROOT_DIR"
echo "🛠  Creating output file: $OUTPUT_FILE"
echo "🪪 Using Phrase project ID: $PHRASE_PROJECT_ID"
echo

# Begin writing YAML
{
  echo "phrase:"
  echo "  project_id: $PHRASE_PROJECT_ID"
  echo "  push:"
  echo "    sources:"
} > "$OUTPUT_FILE"

# Counter for how many XML files we find
count=0

# Find all .xml files
while IFS= read -r xml_file; do
  echo "📂 Found: $xml_file"
  ((count++))

  {
    echo "    - file: $xml_file"
    echo "      params:"
    echo "        file_format: xml"
    echo "        locale_id: en"
    echo "        update_translations: true"
  } >> "$OUTPUT_FILE"

done < <(find "$ROOT_DIR" -type f -name "*.xml")

echo
echo "✅ Total .xml files included: $count"
echo "📄 push_config_freddy.yml successfully generated."
