#!/bin/bash

# Set the root directory to search and output file name
ROOT_DIR="./instashopper-android/shared"
OUTPUT_FILE="push_config_freddy.yml"

# Define project ID (replace with your real one if needed)
PHRASE_PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

# Begin writing YAML
cat > "$OUTPUT_FILE" <<EOF
phrase:
  project_id: $PHRASE_PROJECT_ID
  push:
    sources:
EOF

# Find .xml files NOT in locale-specific 'values-' directories (like values-es, values-fr-rCA, etc.)
while IFS= read -r xml_file; do
  # Append to YAML with formatting
  cat >> "$OUTPUT_FILE" <<EOF
    - file: $xml_file
      params:
        file_format: android_xml
        locale_id: en
        update_translations: true
EOF
done < <(find "$ROOT_DIR" -type f -name "*.xml")

echo "✅ push_config_freddy.yml generated successfully."
