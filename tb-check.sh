#!/bin/sh

# Check for --all flag
if [ "$1" = "--all" ]; then
  # Get all .pipe and .datasource files (excluding lib/)
  files=$(find . -name "*.pipe" -o -name "*.datasource" -o -name "*.incl" | grep -v '^./lib/' | sort)
  echo "Checking all Tinybird files..."
else
  # Get the list of staged .pipe and .datasource files
  files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.pipe$|\.datasource$|\.incl$' | grep -v '^lib/')
  echo "Checking staged Tinybird files..."
fi

# Check each file
if [ -n "$files" ]; then
  echo "$files" | while IFS= read -r file; do
    echo "Checking $file"
    if ! uv run tb check "$file"; then
      echo "Tinybird check failed on $file. Please fix the errors before committing."
      exit 1
    fi
  done
fi
