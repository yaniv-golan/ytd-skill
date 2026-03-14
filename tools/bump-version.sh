#!/bin/bash
# Reads version from VERSION file and updates all locations.
# Usage: ./tools/bump-version.sh [new-version]
#   If new-version is provided, updates VERSION file first.
#   If omitted, propagates current VERSION file to all locations.
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION_FILE="$ROOT/VERSION"

if [ -n "$1" ]; then
  echo "$1" > "$VERSION_FILE"
fi

VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"

if [ -z "$VERSION" ]; then
  echo "Error: VERSION file is empty" >&2
  exit 1
fi

sed -i '' "s/\"version\": \"[^\"]*\"/\"version\": \"$VERSION\"/" "$ROOT/.claude-plugin/plugin.json"
sed -i '' "s/\"version\": \"[^\"]*\"/\"version\": \"$VERSION\"/" "$ROOT/.cursor-plugin/plugin.json"
sed -i '' "s/version: \"[^\"]*\"/version: \"$VERSION\"/" "$ROOT/skills/youtube-downloader/SKILL.md"

echo "Version $VERSION applied to:"
echo "  .claude-plugin/plugin.json"
echo "  .cursor-plugin/plugin.json"
echo "  skills/youtube-downloader/SKILL.md"
