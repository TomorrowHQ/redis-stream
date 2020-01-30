require 'redis'
require 'redis_stream/version'
require 'redis_stream/group'
require 'redis_stream/stream'
require 'redis_stream/client'

module RedisStream
  class Error < StandardError; end

  def self.new(redis: nil)
    redis = redis.nil? ? Redis.new : redis
    Client.new(redis)
  end
end
