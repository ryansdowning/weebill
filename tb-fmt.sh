#!/bin/sh

# Check for --all flag
if [ "$1" = "--all" ]; then
  # Get all .pipe and .datasource files (excluding lib/)
  files=$(find . -name "*.pipe" -o -name "*.datasource" -o -name "*.incl" | grep -v '^./lib/' | sort)
  echo "Formatting all Tinybird files..."
else
  # Get the list of staged .pipe and .datasource files
  files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.pipe$|\.datasource$|\.incl$' | grep -v '^lib/')
  echo "Formatting staged Tinybird files..."
fi

# Format each file
if [ -n "$files" ]; then
  echo "$files" | while IFS= read -r file; do
    echo "Formatting $file"
    uv run tb fmt "$file" --yes
  done

  # Check if there are any changes to the formatted files (only for staged files mode)
  if [ "$1" != "--all" ]; then
    for file in $files; do
      if ! git diff --quiet -- "$file"; then
        echo "Tinybird format made changes to: $file"
        echo "Please stage the changes before committing."
        exit 1
      fi
    done
  fi
fi
