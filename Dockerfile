FROM ghcr.io/home-assistant/aarch64-base:latest

RUN apk add --no-cache docker-cli


# Copy the static folder into the container
COPY static/ /tmp/static/

# Copy your script into the container and set executable permissions
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Create a tarball of the static folder contents
RUN tar -czf /tmp/static.tar.gz -C /tmp/static .

CMD [ "/run.sh" ]