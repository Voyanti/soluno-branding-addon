FROM ghcr.io/home-assistant/amd64-base:latest

# Copy your script and assets into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]