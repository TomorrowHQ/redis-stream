# RedisStream

<p align="center">
  <a href="https://codeclimate.com/github/tomorrowhq/redis-stream/maintainability"><img src="https://api.codeclimate.com/v1/badges/73f0d460cf35b758e624/maintainability" /></a>
  <a href="https://codeclimate.com/github/tomorrowhq/redis-stream/test_coverage"><img src="https://api.codeclimate.com/v1/badges/73f0d460cf35b758e624/test_coverage" /></a>
</p>

## Usage

### Setting up

Under the hood RedisStream is using redis gem, which means that you can use it
out of the box if you are using redis. It will be using same `REDIS_URL`
environment variable to establish connection with Redis.

```ruby
# Gemfile

gem "redis_stream", "~> 0.3.0"
```

### Adding messages to the stream

```ruby
require 'redis_stream'

daily_temperature = RedisStream.stream(name: "daily_temperature")

daily_temperature << 20.0
daily_temperature << 21.0
daily_temperature << 22.0

puts daily_temperature.size
#=> 3
```

### Consuming messages from the stream

Stream implements most of operations that can be performed on ruby Array.

```ruby
daily_temperature.each do |temperature|
  puts message
end
# => 20.0
# => 21.0
# => 22.0

puts daily_temperature.last
# => 22.0

puts daily_temperature.first
# => 20.0

average = daily_temperature.sum / daily_temperature.length
min = daily_temperature.min
max = daily_temperature.max
puts "Average: #{average} Min: #{min} Max: #{max}"
```
