#!/bin/bash

# Check if the path to a Git project root is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_git_project_root>"
  exit 1
fi

# Navigate to the Git project root
cd "$1" && PROJECT_ROOT=$(git rev-parse --show-toplevel) || { echo "Invalid path"; exit 1; }

# Retrieve the project name and create the flat file
PROJECT_NAME=$(basename "$PROJECT_ROOT")
FLAT_FILE="${PROJECT_ROOT}/flat_${PROJECT_NAME}.txt"
touch "$FLAT_FILE" || { echo "Failed to create the flat file"; exit 1; }

# Function to check if a file is a binary
is_binary() {
  local file=$1
  if file "$file" | grep -q 'text'; then
    return 1
  else
    return 0
  fi
}

# Function to get file size with wc for portability
get_file_size() {
  wc -c < "$1" || { echo "Failed to get file size for $1"; exit 1; }
}

# Use git ls-files to get a list of all files that are not ignored by .gitignore
git ls-files | while read -r file; do
  # Check for binary file
  if is_binary "$file"; then
    echo "Ignoring binary file: $file"
    continue
  fi

  # Get file size and check if larger than 1MB
  FILE_SIZE=$(get_file_size "$file")
  if [ "$FILE_SIZE" -gt 1048576 ]; then
    echo "Ignoring large file: $file"
    continue
  fi

  # Append relative file path and content to the flat file
  {
    echo "/$file"
    echo '```'
    cat "$file" || { echo "Failed to read file $file"; continue; }
    echo ''
    echo '```'
    echo ''
  } >> "$FLAT_FILE" || { echo "Failed to write to flat file"; exit 1; }
done

echo "Flat file created at $FLAT_FILE"

