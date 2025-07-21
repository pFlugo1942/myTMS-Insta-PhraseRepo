#!/bin/bash

# Set your Phrase project ID
PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"

# Define locales and paths
SOURCE_PATH="./instashopper-android/shared/**/*.xml"
TARGET_LOCALES=("es-rUS" "fr-rCA")
IGNORE_LOCALE_FOLDERS=("values-es-rUS" "values-fr-rCA")

# Start writing the config
cat <<EOF > .phrase.yml
phrase:
  project_id: $PROJECT_ID
  file_format: simple_json
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
  echo "      - '**/${locale}/**'" >> .phrase.yml
done

# Add pull targets
cat <<EOF >> .phrase.yml
  pull:
    targets:
EOF

for locale in "${TARGET_LOCALES[@]}"; do
  cat <<EOF >> .phrase.yml
      - file: ./src/content/${locale}/main.json
        params:
          locale_id: ${locale}
          file_format: simple_json
EOF
done

echo "✅ .phrase.yml has been generated."
