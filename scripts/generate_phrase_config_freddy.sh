#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Set the root directory to search and output file name
ROOT_DIR="./instashopper-android/shared"
OUTPUT_FILE="new_push_config.yml"

# Define project ID (replace with your real one if needed)
PHRASE_PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

echo "🔍 Starting .xml file search in '$ROOT_DIR'..."
echo "🧹 Excluding locale-specific directories like values-es, values-fr-rCA, etc."
echo "📄 Output YAML will be written to: $OUTPUT_FILE"

# Begin writing YAML
cat > "$OUTPUT_FILE" <<EOF
phrase:
  project_id: $PHRASE_PROJECT_ID
  push:
    sources:
EOF

# Counter for matched files
count=0

# Find .xml files NOT in locale-specific 'values-' directories (like values-es, values-fr-rCA, etc.)
while IFS= read -r xml_file; do
  echo "✅ Including file: $xml_file"
  ((count++))

  # Append to YAML with formatting
  cat >> "$OUTPUT_FILE" <<EOF
    - file: $xml_file
      params:
        file_format: android_xml
        locale_id: en
        update_translations: true
EOF
done < <(find "$ROOT_DIR" -type f -name "*.xml")

echo "📦 Found $count XML files for inclusion."
echo "✅ YAML configuration successfully written to: $OUTPUT_FILE"
