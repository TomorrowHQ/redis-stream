require 'redis'

module RedisStream
  class Client
    PREFIX = 'stream-'.freeze

    def initialize
      @redis = Redis.new
    end

    def add(entry, key:)
      @redis.xadd(add_prefix(key), value: entry)
    end

    def len(key:)
      @redis.xlen(add_prefix(key))
    end

    def clear(key:)
      @redis.xtrim(add_prefix(key), 0)
    end

    def each_message(key:)
      last_id = '0'

      while
        result = @redis.xread(add_prefix(key), last_id, count: 1)
        break if result.empty?

        messages = result[add_prefix(key)]
        messages.each do |message|
          last_id, entry = message
          yield(entry['value'])
        end
      end
    end

    private

    def add_prefix(key)
      PREFIX + key
    end
  end
end
