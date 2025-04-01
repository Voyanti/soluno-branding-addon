FROM ghcr.io/home-assistant/amd64-base:latest

COPY static/ /tmp/static/

# Copy your script and assets into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh
RUN tar -czf /tmp/static.tar.gz -C /tmp/static

CMD [ "/run.sh" ]