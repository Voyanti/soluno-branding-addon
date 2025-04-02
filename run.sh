#!/bin/sh

echo "Starting asset injection process..."

# Paths in the add-on container (local copy of your assets)
LOCAL_ASSETS_DIR="/share/asset_injector/static"       # This is where your add-on holds the static assets folder
ARCHIVE_PATH="/share/asset_injector/static.tar.gz"      # The tarball that will be created

# Target settings for the Home Assistant container
HA_CONTAINER="homeassistant"            # The name of the Home Assistant container
HA_STATIC_DIR="/usr/local/lib/python3.13/site-packages/hass_frontend/static"

# Create the tarball if it doesn't exist
if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "Creating archive of local assets..."
  tar -czf "$ARCHIVE_PATH" -C "$LOCAL_ASSETS_DIR" .
else
  echo "Archive already exists at $ARCHIVE_PATH"
fi

# Check if Docker CLI is available
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker command not found. Ensure the Docker CLI is installed and the socket is mounted."
  exit 1
fi

# Copy the tarball to the Home Assistant container
echo "Copying archive to Home Assistant container..."
# docker cp "$ARCHIVE_PATH" "$HA_CONTAINER":/tmp/static.tar.gz

# Extract the archive inside the Home Assistant container
echo "Extracting assets inside Home Assistant container..."
docker exec "$HA_CONTAINER" tar -xzf "$ARCHIVE_PATH" -C "$HA_STATIC_DIR"

echo "Asset injection complete."