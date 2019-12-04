module RedisStream
  class Client
    def initialize
      @streams = {}
    end

    def add(message, key:)
      @streams[key] ||= []
      @streams[key] << message
    end

    def len(key:)
      @streams[key]&.size || 0
    end

    def each_message(key:)
      @streams[key].each { |message| yield(message) }
    end
  end
end
