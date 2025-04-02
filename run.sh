#!/bin/sh

echo "Starting asset injection process..."

# Local copy of your assets (in add-on)
LOCAL_ASSETS_DIR="/share/asset_injector/static"
ARCHIVE_PATH="/share/asset_injector/static.tar.gz"

# Target container and path
HA_CONTAINER="homeassistant"
HA_STATIC_DIR="/usr/local/lib/python3.13/site-packages/hass_frontend/static"

# Create the tarball if it doesn't exist
if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "Creating archive of local assets..."
  tar -czf "$ARCHIVE_PATH" -C "$LOCAL_ASSETS_DIR" .
else
  echo "Archive already exists at $ARCHIVE_PATH"
fi

# Check for Docker CLI
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker command not found."
  exit 1
fi

# Copy the tarball to the Home Assistant container
echo "Copying archive to Home Assistant container..."
docker cp "$ARCHIVE_PATH" "$HA_CONTAINER":/config/static.tar.gz
if [ $? -ne 0 ]; then
  echo "❌ docker cp failed."
  exit 1
fi

# Extract inside Home Assistant container
echo "Extracting assets inside Home Assistant container..."
docker exec "$HA_CONTAINER" tar -xzf /config/static.tar.gz -C "$HA_STATIC_DIR"
if [ $? -ne 0 ]; then
  echo "❌ docker exec failed."
  exit 1
fi

echo "Extraction complete."

# List all files (recursively) in the target directory on the Home Assistant container
echo "Listing extracted files and directory structure in $HA_STATIC_DIR:"
docker exec "$HA_CONTAINER" ls -R "$HA_STATIC_DIR"

# Alternatively, if the container has the 'find' command, you can also use:
# docker exec "$HA_CONTAINER" find "$HA_STATIC_DIR"

echo "✅ Asset injection complete."