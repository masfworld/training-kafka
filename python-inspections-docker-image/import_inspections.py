import json
import csv
import io
from kafka import KafkaProducer
from kafka.errors import KafkaError
from time import sleep
import os
import logging
import requests

logging.basicConfig(level=logging.INFO)

KAFKA_BOOTSTRAP_SERVER = os.environ['KAFKA_BOOTSTRAP_SERVER']

producer = KafkaProducer(bootstrap_servers=KAFKA_BOOTSTRAP_SERVER, value_serializer=lambda x: x.encode('utf-8', 'ignore'))

def readFile(filename):
    f = io.open(filename, encoding="utf-8")
    reader = csv.DictReader(f) # Reading csv file to dictionary
    counter = 0

    for row in reader:

        counter += 1

        rowJson = json.dumps(row) # Converting row to JSON

        future = producer.send("inspections", value = rowJson) # Sending JSON to Kafka

        # Block for 'synchronous' sends
        try:
            record_metadata = future.get(timeout=10)
        except KafkaError:
            logging.error("Error in Kafka")

        # Sleep 5 seconds for each 1000 messages
        if (counter % 10 == 0):
            logging.info("*** Number of messages sent: " + str(counter) + " ***")
            sleep(20)

def download_file(url, filename):
    logging.info("Downloading file...")
    response = requests.get(url)
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(response.text)
    logging.info("File downloaded.")

def main():
    logging.info("***** Main - Start *****")

    url = "https://raw.githubusercontent.com/masfworld/datahack_docker/master/zeppelin/data/food_inspections_lite.csv"
    filename = "./food_inspections_lite.csv"
    download_file(url, filename)

    while True:
        readFile(filename)

if __name__ == "__main__":
    main()