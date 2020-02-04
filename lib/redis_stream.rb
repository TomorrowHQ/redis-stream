require 'redis'
require 'redis_stream/version'
require 'redis_stream/group'
require 'redis_stream/stream'

class RedisStream
  class Error < StandardError; end

  def initialize(redis: Redis.new)
    @redis = redis
  end

  def stream(key)
    Stream.new(redis: @redis, key: key)
  end

  def group(key:, name:)
    new_group = Group.new(redis: @redis, key: key, name: name)
    new_group.create
  end
end
