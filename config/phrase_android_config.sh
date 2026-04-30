#!/bin/bash
# Configuration for Phrase Android script

# Base configuration
base_dir="./instashopper-android/shared"
config_file="./test_freddy_config.yml"
project_id="15d32bafd4ffe92f156bcca0549a07e6"

# Folders to exclude when scanning for XML files
excluded_folders=("values-es-rUS" "values-fr-rCA")

# Define locale to Android code mapping
declare -A locale_android_map=(
  ["es-US"]="es-rUS"
  ["fr-CA"]="fr-rCA"
)
