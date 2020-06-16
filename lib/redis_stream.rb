require 'redis'
require 'redis_stream/version'
require 'redis_stream/group'
require 'redis_stream/stream'
require 'redis_stream/consumer'
require 'redis_stream/client'

module RedisStream
  class Error < StandardError; end

  # @param name <String> Name of a stream
  # @return <RedisStream::Stream>
  def self.stream(name:)
    Stream.new(name: name)
  end

  # @param name <String> Name of a group
  # @param stream <RedisStream::Stream> Stream that group should consume
  # @return <RedisStream::Group>
  def self.group(name:, stream:)
    Group.new(name: name, stream: stream)
  end
end
