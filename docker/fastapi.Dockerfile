FROM python:3.10.1-slim

ARG USER_NAME=appuser
ARG USER_ID=1001

RUN groupadd -g $USER_ID $USER_NAME && \
    useradd -g $USER_ID -m -u $USER_ID -s /bin/bash $USER_NAME && \
    chgrp -R 0 /home/$USER_NAME && \
    chmod -R g=u /home/$USER_NAME

WORKDIR /app

COPY src/api /app/src/api
COPY src/model.py /app/src/model.py
COPY model_assets /app/model_assets

COPY --chown=$USER_ID:$USER_ID docker/fastapi_requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r fastapi_requirements.txt


COPY --chown=$USER_ID:$USER_ID . .

EXPOSE 8000

CMD ["uvicorn", "src.api.server:app", "--host", "0.0.0.0", "--port", "8000"]