class RedisStream
  class Client
    def initialize(redis)
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
end
