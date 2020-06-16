module RedisStream
  class Stream
    include Enumerable

    attr_reader :name

    def initialize(name:)
      @name = name
      @values = []
    end

    def <<(value)
      Redis.current.xadd(name, dump(value))
      self
    end
    alias_method :push, :<<

    def clear
      Redis.current.xtrim(name, 0)
    end

    def last(count = 1)
      messages = Redis.current.xrevrange(name, '+', '-', count: count)
      messages.reverse!

      result = messages.map do |message|
        _id, content = message
        load(content)
      end

      count == 1 ? result.first : result
    end

    def length
      Redis.current.xlen(name)
    end
    alias_method :size, :length

    def each(&block)
      current_message_id = "0"

      while
        result = Redis.current.xread(name, current_message_id, count: 1)
        break if result.empty?

        message = result[name].first
        current_message_id, message_content = message
        block.call(load(message_content))
      end
    end

    private

    def dump(value)
      { value: Marshal.dump(value) }
    end

    def load(message_content)
      Marshal.load(message_content["value"])
    end
  end
end
