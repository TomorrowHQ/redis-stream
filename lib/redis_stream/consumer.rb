module RedisStream
  class Consumer
    include Enumerable

    attr_reader :name, :group, :stream

    def initialize(name:, group:, stream:)
      @name = name
      @group = group
      @stream = stream
    end

    def each(&block)
      while
        result = read_next
        break if result.empty?

        message = result[stream.name].first
        id, content = message
        block.call(load(content))
        Redis.current.xack(stream.name, name, id)
      end
    end

    private

    def read_next
      Redis.current.xreadgroup(group.name, name, stream.name, '>', count: 1)
    end

    def load(message_content)
      Marshal.load(message_content["value"])
    end
  end
end
