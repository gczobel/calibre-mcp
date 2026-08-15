FROM python:3.12-slim

RUN pip install --no-cache-dir git+https://github.com/ajtudela/calibre_mcp_server.git

ENV TRANSPORT_MODE=http \
    HTTP_HOST=0.0.0.0 \
    HTTP_PORT=9001

EXPOSE 9001

CMD ["python3", "-m", "calibre_mcp_server"]
