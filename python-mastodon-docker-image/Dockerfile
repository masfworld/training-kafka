FROM python:3.8-slim-buster

WORKDIR /app

COPY . .

RUN pip3 install Mastodon.py==1.8.1 kafka-python==2.0.2 google-cloud-secret-manager

CMD [ "python3", "./import_mastodon.py" ]