FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_CREATE=false

WORKDIR /websocket_echo

COPY pyproject.toml poetry.lock ./

RUN pip install poetry \
    && poetry install --no-dev --no-interaction

COPY . ./

RUN poetry install --no-dev --no-interaction

ENTRYPOINT [ "python" ]
