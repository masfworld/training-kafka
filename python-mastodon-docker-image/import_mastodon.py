#!/usr/bin/env python3
from mastodon import Mastodon, StreamListener
from kafka import KafkaProducer
import json
from google.cloud import secretmanager
import os

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
MASTODON_ACCESS_TOKEN = access_secret_version("training-386613", "MASTODON_ACCESS_TOKEN", "latest")

# Initialize Mastodon API Client
mastodon = Mastodon(
    access_token=MASTODON_ACCESS_TOKEN,
    # Use your own instance url
    api_base_url='https://owo.cafe'
)

# Read environment variables
KAFKA_BOOTSTRAP_SERVER = os.environ['KAFKA_BOOTSTRAP_SERVER']

# Initialize Kafka Producer
producer = KafkaProducer(bootstrap_servers=[KAFKA_BOOTSTRAP_SERVER],
                         value_serializer=lambda x: json.dumps(x).encode('utf-8'))

class MyStreamListener(StreamListener):
    def on_update(self, status):
        # Customize the toot as needed
        toot_data = {
            'id': status['id'],
            'content': status['content'],
            'created_at': str(status['created_at']),
            'account': status['account']['acct']
        }
        # Send toot to Kafka
        producer.send('toots', value=toot_data)
        print(f"Sent toot {status['id'], status['content'], status['account'], status['created_at']} to Kafka topic 'toots'.")

# Create stream listener
listener = MyStreamListener()

# Start streaming public toots
mastodon.stream_public(listener, run_async=False)
