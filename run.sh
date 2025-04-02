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
docker cp "$ARCHIVE_PATH" "$HA_CONTAINER":/tmp/static.tar.gz
if [ $? -ne 0 ]; then
  echo "❌ docker cp failed."
  exit 1
fi

# Extract inside Home Assistant container
echo "Extracting assets inside Home Assistant container..."
docker exec "$HA_CONTAINER" tar -xzf /tmp/static.tar.gz -C "$HA_STATIC_DIR"
if [ $? -ne 0 ]; then
  echo "❌ docker exec failed."
  exit 1
fi

echo "✅ Asset injection complete."