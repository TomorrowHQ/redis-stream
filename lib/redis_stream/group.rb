module RedisStream
  class Group
    attr_reader :key, :name

    def initialize(redis:, key:, name:)
      @redis = redis
      @key = key
      @name = name
      @last_delivered_id = '0'
    end

    # Creates group and stream if group does not exist.
    # @return [Group]
    def create
      if info.nil?
        @redis.xgroup(:create, key, name, @last_delivered_id, mkstream: true)
      end

      self
    end

    # @return [Group]
    def destroy
      @redis.xgroup(:destroy, key, name)
      self
    end

    def info
      find_me(@redis.xinfo(:groups, key))
    rescue Redis::CommandError
      nil
    end

    def each_message(consumer: 'c1', ack: true)
      while
        result = @redis.xreadgroup(name, consumer, key, '>')
        break if result.empty?

        messages = result[key]
        messages.each do |message|
          id, entry = message
          yield(entry['value'])
          @redis.xack(key, name, id) if ack
        end
      end
    end

    private

    def find_me(groups)
      groups.find { |group| group['name'] == name }
    end
  end
end
