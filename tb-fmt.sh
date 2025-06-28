#!/bin/sh

# Get the list of staged .pipe and .datasource files
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.pipe$|\.datasource$|\.incl$' | grep -v '^lib/')

# Format each staged file
if [ -n "$staged_files" ]; then
  echo "$staged_files" | while IFS= read -r file; do
    echo "Formatting $file"
    uv run tb fmt "$file" --yes
  done

  # Check if there are any changes after formatting
  if ! git diff --quiet; then
    echo "Tinybird format made changes. Please stage the changes before committing."
    exit 1
  fi
fi
