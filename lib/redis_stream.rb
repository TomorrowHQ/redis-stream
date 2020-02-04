require 'redis'
require 'redis_stream/version'
require 'redis_stream/group'
require 'redis_stream/stream'
require 'redis_stream/client'

class RedisStream
  class Error < StandardError; end

  def initialize(redis: Redis.new)
    Client.new(redis)
  end
end
