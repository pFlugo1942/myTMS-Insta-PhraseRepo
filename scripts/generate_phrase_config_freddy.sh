#!/bin/bash

# Set your Phrase project ID
PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

# Define paths and locales
SOURCE_ROOT="./instashopper-android/shared"
SOURCE_PATH="./instashopper-android/shared/**/*.xml"
TARGET_LOCALES=("es-rUS" "fr-rCA")
IGNORE_LOCALE_FOLDERS=("values-es-rUS" "values-fr-rCA")

# Start config file
cat <<EOF > .new-test-phrase.yml
phrase:
  project_id: $PROJECT_ID
  file_format: xml
  push:
    sources:
EOF

# Add all matching source files explicitly
find "$SOURCE_ROOT" -type f -name "*.xml" | sort | while read -r file; do
  rel_path="./${file}"
  echo "📁 Processing: ${rel_path}"

  cat <<EOF >> .new-test-phrase.yml
      - file: ${rel_path}
        params:
          locale_id: en
          update_translations: true
EOF
done

# Add ignored folders
echo "    ignore:" >> .new-test-phrase.yml
for locale in "${IGNORE_LOCALE_FOLDERS[@]}"; do
  echo "      - '**/${locale}/**'" >> .new-test-phrase.yml
done

# Add pull targets
cat <<EOF >> .new-test-phrase.yml
  pull:
    targets:
EOF

for locale in "${TARGET_LOCALES[@]}"; do
  cat <<EOF >> .new-test-phrase.yml
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
