FROM python:3.12.3-slim

WORKDIR /app

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     curl \
#     git \
#     && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY . .

ENV PORT=8080
EXPOSE 8080
