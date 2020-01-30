require 'test_helper'

describe RedisStream::Stream do
  before do
    @redis = Redis.new
    @redis.xtrim('test-1', 0)
    @redis.xtrim('test-2', 0)
  end

  describe '#add' do
    it 'adds a message to redis stream' do
      stream_1 = RedisStream::Stream.new(key: 'test-1', redis: @redis)
      stream_2 = RedisStream::Stream.new(key: 'test-2', redis: @redis)

      stream_1.add({ message: 'Message' })

      assert_equal 1, @redis.xlen(stream_1.key)
      assert_equal 0, @redis.xlen(stream_2.key)

      stream_2.add({ message: 'Message' })
      stream_2.add({ message: 'Message' })

      assert_equal 2, @redis.xlen(stream_2.key)
      assert_equal 1, @redis.xlen(stream_1.key)
    end
  end

  describe '#len' do
    it 'returns number of entries in the stream' do
      stream = RedisStream::Stream.new(key: 'test-1', redis: @redis)

      assert_equal 0, stream.len

      @redis.xadd('test-1', { value: 'Hello' })

      assert_equal 1, stream.len
    end
  end

  describe '#clear' do
    it 'returns number of entries in the stream' do
      stream = RedisStream::Stream.new(key: 'test-1', redis: @redis)

      @redis.xadd('test-1', { value: 'Hello 1' })
      @redis.xadd('test-1', { value: 'Hello 2' })

      assert_equal 2, @redis.xlen(stream.key)

      stream.clear

      assert_equal 0, @redis.xlen(stream.key)
    end
  end

  describe '#last' do
    it 'retuns last message added to the stream' do
      stream = RedisStream::Stream.new(key: 'test-1', redis: @redis)

      @redis.xadd('test-1', { 'value' => '1' })
      @redis.xadd('test-1', { 'value' => '2' })

      assert_equal({ 'value' => '2' }, stream.last)

      stream.clear

      assert_nil stream.last
    end
  end

  describe '#first' do
    it 'retuns first message added to the stream' do
      stream = RedisStream::Stream.new(key: 'test-1', redis: @redis)

      @redis.xadd('test-1', { 'value' => '1' })
      @redis.xadd('test-1', { 'value' => '2' })

      assert_equal({ 'value' => '1' }, stream.first)

      stream.clear

      assert_nil stream.first
    end
  end
end
