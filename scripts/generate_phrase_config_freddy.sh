#!/bin/bash

# Define constants
ROOT_DIR="./instashopper-android/shared"
SOURCE_LOCALE="en"
PHRASE_PROJECT_ID="15d32bafd4ffe92f156bcca0549a07e6"
OUTPUT_FILE="push_config_freddy.yml"

# Temp arrays to store source and translation file paths
declare -a source_files
declare -A translation_targets

# Function to detect and extract locale from path (for demonstration)
extract_locale() {
  local filepath="$1"
  if [[ "$filepath" =~ translation-files/([a-z]{2})/ ]]; then
    echo "${BASH_REMATCH[1]}"
  fi
}

# Find files excluding those in locale-specific values-* directories
while IFS= read -r file; do
  source_files+=("$file")

  # Create translation target entries for demonstration
  # You can modify this to dynamically detect available locales
  for locale in de es el; do
    # Replace ./source-locale/... with ./translation-files/<locale>/...
    relative_path="${file#./source-locale/}"
    translation_path="./translation-files/$locale/$relative_path"
    translation_targets["$translation_path"]="$locale"
  done

done < <(find "$ROOT_DIR/source-locale" -type f ! -regex '.*/values-[a-z][a-z]\(-r[A-Z][A-Z]\)\?(/.*)?')

# Start writing to .phrase.yml
echo "phrase:" > "$OUTPUT_FILE"
echo "  project_id: $PHRASE_PROJECT_ID" >> "$OUTPUT_FILE"
echo "  push:" >> "$OUTPUT_FILE"
echo "    sources:" >> "$OUTPUT_FILE"

# Write source files
for src in "${source_files[@]}"; do
cat >> "$OUTPUT_FILE" <<EOF
    - file: $src
      params:
        file_format: simple_json
        locale_id: $SOURCE_LOCALE
        update_translations: true
EOF
done

# Write pull targets
echo "  pull:" >> "$OUTPUT_FILE"
echo "    targets:" >> "$OUTPUT_FILE"

for path in "${!translation_targets[@]}"; do
  locale="${translation_targets[$path]}"
cat >> "$OUTPUT_FILE" <<EOF
    - file: $path
      params:
        locale_id: $locale
        file_format: simple_json
EOF
done

echo ".phrase.yml generated successfully."
