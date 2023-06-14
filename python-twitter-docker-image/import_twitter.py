#!/usr/bin/env python3
import os
import tweepy
import json
from kafka import KafkaProducer
import time
from google.cloud import secretmanager
import logging

logging.basicConfig(level=logging.INFO)

def access_secret_version(project_id, secret_id, version_id):
    """
    Access the payload for the given secret version if one exists. The version
    can be a version number as a string (e.g. "5") or an alias (e.g. "latest").
    """

    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version.
    response = client.access_secret_version(request={"name": name})

    # Return the decoded payload.
    return response.payload.data.decode('UTF-8')

# Access the secret using the function
BEARER_TOKEN = access_secret_version("training-386613", "BEARER_TOKEN", "latest")

# Read environment variables
KAFKA_BOOTSTRAP_SERVER = os.environ['KAFKA_BOOTSTRAP_SERVER']

# Create an instance of the Kafka Producer
producer = KafkaProducer(bootstrap_servers=KAFKA_BOOTSTRAP_SERVER, value_serializer=lambda v: json.dumps(v).encode('utf-8'))

client = tweepy.Client(BEARER_TOKEN)

query = 'biden -is:retweet'

while True:
    tweets = client.search_recent_tweets(query=query, tweet_fields=['id', 'created_at', 'author_id', 'geo', 'lang', 'text', 'context_annotations'], max_results=100)

    for tweet in tweets.data:
        # Prepare the data to be sent
        data = {
            'id': tweet.id,
            'created_at': tweet.created_at.isoformat(),
            'author_id': tweet.author_id,
            'geo': tweet.geo,
            'lang': tweet.lang,
            'text': tweet.text
        }
        # Send the data to the 'twitter' topic
        producer.send('twitter', value=data)

    # Ensure all messages have been sent
    producer.flush()

    # Wait for 20 seconds before the next search
    logging.info("Generating 100 tweets. Waiting for 20 seconds")
    time.sleep(20)