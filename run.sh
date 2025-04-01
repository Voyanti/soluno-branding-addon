#!/bin/sh

echo "Injecting custom frontend assets..."

# Define paths
HA_STATIC_DIR="/usr/local/lib/python3.13/site-packages/hass_frontend/static"
ARCHIVE_PATH="/data/static.tar.gz"

# Ensure the target directory exists
if [ ! -d "$HA_STATIC_DIR" ]; then
    echo "Target directory $HA_STATIC_DIR does not exist! Exiting."
    exit 1
fi

# Check for archive
if [ -f "$ARCHIVE_PATH" ]; then
    echo "Found archive at $ARCHIVE_PATH, extracting into $HA_STATIC_DIR..."
    tar -xzf "$ARCHIVE_PATH" -C "$HA_STATIC_DIR"
    echo "Extraction complete."
else
    echo "Archive not found at $ARCHIVE_PATH. Skipping."
fi

echo "Done. Exiting."