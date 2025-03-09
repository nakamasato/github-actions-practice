FROM python:3.12.3-slim

ARG VERSION=unknown
ENV VERSION=$VERSION

WORKDIR /app

# apt のキャッシュ
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

COPY . .

ENV PORT=8080
EXPOSE 8080
