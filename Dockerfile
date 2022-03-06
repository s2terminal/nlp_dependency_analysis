FROM python:3.9-slim

WORKDIR /app
ENV PYTHONPATH="/app:$PYTHONPATH"

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install poetry

COPY pyproject.toml ./
COPY poetry.lock ./
RUN poetry install
