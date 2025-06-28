#!/bin/sh

echo "Running Tinybird build..."
if ! uv run python -m lib.build; then
  echo "Build failed. Exiting."
  exit 1
fi

echo "Running Tinybird format..."
if ! ./tb-fmt.sh; then
  echo "Format failed. Exiting."
  exit 1
fi

echo "Running Tinybird check..."
if ! ./tb-check.sh; then
  echo "Check failed. Exiting."
  exit 1
fi

echo "Build, format, and check completed successfully!"