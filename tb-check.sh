#!/bin/sh

# Get the list of staged .pipe and .datasource files
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.pipe$|\.datasource$|\.incl$' | grep -v '^lib/')

# Check each staged file
if [ -n "$staged_files" ]; then
  echo "$staged_files" | while IFS= read -r file; do
    echo "Checking $file"
    if ! uv run tb check "$file"; then
      echo "Tinybird check failed on $file. Please fix the errors before committing."
      exit 1
    fi
  done
fi
