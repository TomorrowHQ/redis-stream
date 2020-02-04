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
client = RedisStream.new(redis: redis)
```

### Adding messages to the stream

```ruby
require 'redis_stream'

client = RedisStream.new

weather_stream = client.stream('weather')

weather_stream.add({ temp: 20.0 })
weather_stream.add({ temp: 21.0 })
weather_stream.add({ temp: 22.0 })

puts weather_stream.len
#=> 3
```

### Consuming messages from the stream

```ruby
require 'redis_stream'

client = RedisStream.new
messages_stream = client.stream('messages')

messages_stream.add({ msg: 'Message 1' })
messages_stream.add({ msg: 'Message 2' })

messages_stream.each_message do |message|
  puts message
end
# => { "msg" => Message 1 }
# => { "msg" => Message 2 }

puts messages_stream.last
# => { "msg" => Message 2 }

puts messages_stream.first
# => { "msg" => Message 2 }
```

### Creating consumer group

One of most powerful features of redis stream is consumer groups which works in
similar way as Kafka consumer groups.

Here is an example of how you can create one.
```ruby
require 'redis_stream'

client = RedisStream.new
group = client.group(key: 'messages', name: 'message-readers')

puts group.info
# => {"name"=>"message-readers", "consumers"=>0, "pending"=>0,
#     "last-delivered-id"=>"0-0"}
```

### Consuming messages as group

API for consuming messages as group looks the same as consuming directly from
the stream. One main difference is that Redis memorizes position of group and
continues reading only new messages.

Here is an example:
```ruby
require 'redis_stream'

client = RedisStream.new

stream = client.stream('messages')
group = client.group(key: 'messages', name: 'message-readers')

stream.add({ content: 'Hello' })
group.each_message do |message|
  puts message
end
# => {"content"=>"Hello"}

stream.add({ content: 'How are you?' })
group.each_message do |message|
  puts message
end
# => {"content"=>"How are you?"}
```

### Delete consumer group

You can delete a group from Redis and it will erase it's position on a stream.

```ruby
require 'redis_stream'

client = RedisStream.new
group = client.group(key: 'messages', name: 'message-readers')

group.destroy
```
