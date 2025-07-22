#!/bin/bash

# Set your Phrase project ID
PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

# Define locales and paths
SOURCE_PATH="./instashopper-android/shared/**/*.xml"
TARGET_LOCALES=("es-rUS" "fr-rCA")
IGNORE_LOCALE_FOLDERS=("values-es-rUS" "values-fr-rCA")

# Start writing the config
cat <<EOF > .test-push_config.yml
phrase:
  project_id: $PROJECT_ID
  file_format: xml
  push:
    sources:
      - file: $SOURCE_PATH
        params:
          locale_id: en
          update_translations: true
    ignore:
EOF

# Add ignored folders
for locale in "${IGNORE_LOCALE_FOLDERS[@]}"; do
  echo "      - '**/${locale}/**'" >> .test-push_config.yml
done

# Add pull targets
cat <<EOF >> .test-push_config.yml
  pull:
    targets:
EOF

for locale in "${TARGET_LOCALES[@]}"; do
  cat <<EOF >> .test-push_config.yml
      - file: ./instashopper-android/shared/**/content/${locale}/strings.xml
        params:
          locale_id: ${locale}
          file_format: xml
EOF
done

# Confirm file creation
echo "✅ .test-push_config.yml has been generated."

# Git operations
git add .test-push_config.yml

if git diff --cached --quiet; then
  echo "ℹ️  No changes to commit."
else
  git commit -m "Add/update .test-push_config.yml for Phrase Strings integration"
  echo "✅ Changes committed to Git."
fi

