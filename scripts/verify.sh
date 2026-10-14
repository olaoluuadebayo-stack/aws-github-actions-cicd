#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBSITE_DIR="$PROJECT_ROOT/website"
HTML_FILE="$WEBSITE_DIR/index.html"
CSS_FILE="$WEBSITE_DIR/style.css"

echo "Starting website verification..."

if [[ ! -s "$HTML_FILE" ]]; then
  echo "ERROR: index.html is missing or empty."
  exit 1
fi

if [[ ! -s "$CSS_FILE" ]]; then
  echo "ERROR: style.css is missing or empty."
  exit 1
fi

if ! grep -qi '<!DOCTYPE html>' "$HTML_FILE"; then
  echo "ERROR: HTML document declaration is missing."
  exit 1
fi

if ! grep -qi '<html' "$HTML_FILE"; then
  echo "ERROR: HTML root element is missing."
  exit 1
fi

if ! grep -q 'style.css' "$HTML_FILE"; then
  echo "ERROR: Stylesheet reference is missing."
  exit 1
fi

echo "PASS: Website files exist and basic HTML checks passed."