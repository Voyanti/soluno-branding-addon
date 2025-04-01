cd static
tar czf static.tar.gz .
docker cp static.tar.gz homeassistant:/tmp/static.tar.gz
docker exec -it homeassistant sh -c "tar xzf /tmp/static.tar.gz -C /usr/local/lib/python3.13/site-packages/hass_frontend/static"