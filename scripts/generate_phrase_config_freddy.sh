#!/bin/bash

# Base configuration
base_dir="./instashopper-android/shared"
config_file="./freddy_test_push_config.yml"
project_id="15d32bafd4ffe92f156bcca0549a07e6"
excluded_folders=("values-es-rUS" "values-fr-rCA")

# Initialize YAML config
cat > "$config_file" <<EOF
phrase:
  project_id: $project_id
  file_format: xml
  push:
    sources:
EOF

# Function to check if file is in an excluded folder
is_excluded() {
  for excl in "${excluded_folders[@]}"; do
    [[ "$1" == *"$excl"* ]] && return 0
  done
  return 1
}

# Function to append a YAML block (used for push and pull)
append_yaml_block() {
  local file_path="$1"
  local locale_id="$2"
  local is_pull="$3"
  local file_name
  local folder_path
  local folder_name
  local unique_id

  folder_path=$(dirname "$file_path")
  file_name=$(basename "$file_path")
  folder_name=$(basename "$folder_path")
  unique_id="folder_$counter"

  if [[ "$is_pull" == "true" ]]; then
    echo "    - file: $folder_path-<locale_code>/$file_name" >> "$config_file"
  else
    echo "    - file: $folder_path/$file_name" >> "$config_file"
  fi

  cat <<EOF >> "$config_file"
      params:
        file_format: xml
        locale_id: $locale_id
EOF

  if [[ "$is_pull" != "true" ]]; then
    echo "        update_translations: true" >> "$config_file"
  fi

  cat <<EOF >> "$config_file"
        tags: $unique_id
        unique_id: $unique_id
EOF

  echo "📄 Processed: $file_path"
  ((counter++))
}

# Process push sources
counter=1
while IFS= read -r file_path; do
  if is_excluded "$file_path"; then
    echo "⏭️  Skipping (excluded): $file_path"
    continue
  fi
  append_yaml_block "$file_path" "en" "false"
done < <(find "$base_dir" -type f -name "*.xml")

# Begin pull section
echo "  pull:" >> "$config_file"
echo "    targets:" >> "$config_file"

# Process pull targets
counter=1
while IFS= read -r file_path; do
  if is_excluded "$file_path"; then
    echo "⏭️  Skipping (excluded): $file_path"
    continue
  fi
  append_yaml_block "$file_path" "<locale_code>" "true"
done < <(find "$base_dir" -type f -name "*.xml")

# Git operations
git add "$config_file"

if git diff --cached --quiet; then
  echo "ℹ️  No changes to commit."
else
  git commit -m "Add/update $config_file for Phrase Strings integration"
  echo "✅ Changes committed to Git."
fi
