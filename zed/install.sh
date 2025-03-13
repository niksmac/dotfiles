#!/bin/bash

ZED_HOME_DIR="$HOME/.dotfiles/zed/"

ln -sf "$ZED_HOME_DIR/settings.json" "$HOME/.config/zed/settings.json"

# ----- symlink snippets
# Define the source subfolder containing JSON files
SOURCE_DIR="$HOME/.dotfiles/zed/snippets"

# Define the target directory where symlinks will be created
TARGET_DIR="$HOME/.config/zed/snippets"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Iterate over all JSON files in the subfolder and create symlinks
for file in "$SOURCE_DIR"/*.json; do
  if [ -f "$file" ]; then
    ln -sf "$file" "$TARGET_DIR/$(basename "$file")"
    echo "Created symlink for $file in $TARGET_DIR"
  fi
done


# ----- symlink prompt templates

# Define the source subfolder containing HBS files
PROMPT_SOURCE_DIR="$HOME/.dotfiles/zed/prompts/templates"

# Define the target directory where symlinks will be created
PROMPT_TARGET_DIR="$HOME/.config/zed/prompt_overrides"

# Create the target directory if it doesn't exist
mkdir -p "$PROMPT_TARGET_DIR"

# Iterate over all JSON files in the subfolder and create symlinks
for file in "$PROMPT_SOURCE_DIR"/*.hbs; do
  if [ -f "$file" ]; then
    ln -sf "$file" "$PROMPT_TARGET_DIR/$(basename "$file")"
    echo "Created symlink for $file in $PROMPT_TARGET_DIR"
  fi
done
