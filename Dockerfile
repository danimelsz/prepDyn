FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MPLCONFIGDIR=/tmp/matplotlib

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends mafft \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml setup.py README.md /app/
COPY src /app/src
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir . \
    && chmod +x /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["--help"]
