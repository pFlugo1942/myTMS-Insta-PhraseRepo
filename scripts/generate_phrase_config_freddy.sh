#!/bin/bash

# Set your Phrase project ID
PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

# Define paths and locales
SOURCE_ROOT="./instashopper-android/shared"
SOURCE_PATH="./instashopper-android/shared/**/*.xml"
TARGET_LOCALES=("es-rUS" "fr-rCA")
IGNORE_LOCALE_FOLDERS=("values-es-rUS" "values-fr-rCA")
OUTPUT_FILE=".new-test-phrase.yml"

# Start config file
cat <<EOF > "$OUTPUT_FILE"
phrase:
  project_id: $PROJECT_ID
  file_format: xml
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
done < <(find "$SOURCE_ROOT" -type f -name "*.xml")

# Add ignored folders
echo "    ignore:" >> "$OUTPUT_FILE"
for locale in "${IGNORE_LOCALE_FOLDERS[@]}"; do
  echo "      - '**/${locale}/**'" >> "$OUTPUT_FILE"
done

# Add pull targets
cat <<EOF >> "$OUTPUT_FILE"
  pull:
    targets:
EOF

for locale in "${TARGET_LOCALES[@]}"; do
  cat <<EOF >> "$OUTPUT_FILE"
      - file: ./instashopper-android/shared/content/${locale}/strings.xml
        params:
          locale_id: ${locale}
          file_format: xml
EOF
done

# Confirm file creation
echo "✅ .new-test-phrase.yml has been generated."

# Git operations
git add .new-test-phrase.yml

if git diff --cached --quiet; then
  echo "ℹ️  No changes to commit."
else
  git commit -m "Add/update .new-test-phrase.yml for Phrase Strings integration"
  echo "✅ Changes committed to Git."
fi
