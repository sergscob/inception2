FROM alpine:3.19

RUN apk add --no-cache python3 py3-pip bash curl

WORKDIR /app

COPY requirements.txt monitor.py entrypoint.sh ./

RUN python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install --no-cache-dir -r requirements.txt \
    && chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]