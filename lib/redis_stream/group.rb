module RedisStream
  class Group
    attr_reader :name, :stream

    # @param name <String>
    # @param stream <RedisStream::Stream>
    # @return RedisStream::Group
    def initialize(name:, stream:)
      @name = name
      @stream = stream

      create_group
    end

    # @param name <String> Consumer name
    # @return <RedisStream::Consumer>
    def consumer(name)
      RedisStream::Consumer.new(name: name, group: self, stream: stream)
    end

    # Resets group's next id on the stream
    def reset(id = "0")
      Redis.current.xgroup(:setid, stream.name, name, id)
      self
    end

    private

    def create_group
      Redis.current.xgroup(
        :create, stream.name, name, "$", mkstream: true)
    rescue Redis::CommandError
      nil
    end
  end
end
