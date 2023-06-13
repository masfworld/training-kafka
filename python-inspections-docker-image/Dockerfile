FROM python:3.8-slim-buster

WORKDIR /app

COPY . .

RUN pip3 install kafka-python==2.0.2 requests

CMD [ "python3", "./import_inspections.py" ]