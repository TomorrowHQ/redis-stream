module RedisStream
  class Client
    PREFIX = 'stream-'.freeze

    def initialize
      @redis = Redis.new
    end

    def add(entry, key:)
      @redis.xadd(key, value: entry)
    end

    def len(key:)
      @redis.xlen(key)
    end

    def clear(key:)
      @redis.xtrim(key, 0)
    end

    def each_message(key:)
      last_id = '0'

      while
        result = @redis.xread(key, last_id, count: 1)
        break if result.empty?

        messages = result[key]
        messages.each do |message|
          last_id, entry = message
          yield(entry['value'])
        end
      end
    end

    def group(key:, name:)
      new_group = Group.new(redis: @redis, key: key, name: name)
      new_group.create
    end
  end
end
