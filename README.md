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

When you need to have control over redis connection you can pass redis instance
in initializer.

```ruby
require 'redis_stream'

redis = Redis.new # set it up as you need
client = RedisStream.new(redis)
```

### Adding messages to the stream

```ruby
require 'redis_stream'

client = RedisStream.new

weather_stream = client.stream('weather')

weather_stream.add(20.0)
weather_stream.add(21.0)
weather_stream.add(22.0)

puts weather_stream.len
#=> 3
```

### Consuming messages from the stream

```ruby
require 'redis_stream'

client = RedisStream.new
messages_stream = client.stream('messages')

messages_stream.add('Message 1')
messages_stream.add('Message 2')

messages_stream.each_message do |message|
  puts message
end
# => Message 1
# => Message 2
```
