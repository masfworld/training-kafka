from confluent_kafka import Producer, Consumer, KafkaException

# Producer configuration
# Replace 'bootstrap.servers' with the load balancer IP and port
p = Producer({'bootstrap.servers': '34.73.156.117:9094'})

# Try to produce a message
try:
    p.produce('test', 'test message')
except KafkaException as e:
    print(f'Exception occurred: {e}')
    pass

# Wait for any outstanding messages to be delivered and delivery reports to be received.
p.flush()

# Consumer configuration
# Replace 'bootstrap.servers' and 'group.id' with the load balancer IP and port and your consumer group
c = Consumer({
    'bootstrap.servers': '34.73.156.117:9094',
    'group.id': 'mygroup',
    'auto.offset.reset': 'earliest'
})

c.subscribe(['test'])

# Try to consume a message
try:
    msg = c.poll(3.0)  # Wait for up to 1 second
    if msg is None:
        print('No message received')
    elif msg.error():
        print(f'Error: {msg.error()}')
    else:
        # Proper message
        print(f'Message received: {msg.value().decode("utf-8")}')
except KafkaException as e:
    print(f'Exception occurred: {e}')
    pass

c.close()
