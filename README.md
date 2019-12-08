# RedisStream

<p align="center">
  <a href="https://codeclimate.com/github/tomorrowhq/redis-stream/maintainability"><img src="https://api.codeclimate.com/v1/badges/73f0d460cf35b758e624/maintainability" /></a>
  <a href="https://codeclimate.com/github/tomorrowhq/redis-stream/test_coverage"><img src="https://api.codeclimate.com/v1/badges/73f0d460cf35b758e624/test_coverage" /></a>
</p>

## Status

Currently project is under active development.

## Usage

### Setting up

Under the hood RedisStream is using redis gem, which means that you can use it
out of the box if you are using redis. It will be using same `REDIS_URL`
environment variable to establish connection with Redis.

```ruby
require 'redis_stream'

client = RedisStream.new
```

### Adding messages to the stream

```ruby
require 'redis_stream'

client = RedisStream.new

# First argument is body of the message that will placed into the stream. Second
# argument refers to Redis stream key.
client.add(20.0, key: 'weather')
client.add(21.0, key: 'weather')
client.add(22.0, key: 'weather')
```

### Consuming messages from the stream

```ruby
require 'redis_stream'

client = RedisStream.new

client.add('Message 1', key: 'messages')
client.add('Message 2', key: 'messages')

client.each_message(key: 'messages') do |message|
  puts message
end
# => Message 1
# => Message 2
```
