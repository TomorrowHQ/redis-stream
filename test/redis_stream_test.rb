require 'test_helper'

describe RedisStream do
  it 'defines a version' do
    refute_nil ::RedisStream::VERSION
  end

  it 'puts messages in redis stream' do
    stream = RedisStream.new

    stream.add('Message', key: 'test-1')
    assert_equal 1, stream.len(key: 'test-1')
    assert_equal 0, stream.len(key: 'test-2')

    stream.add('Message', key: 'test-2')
    assert_equal 1, stream.len(key: 'test-2')
    assert_equal 1, stream.len(key: 'test-1')
  end

  it 'reads messages from redis stream' do
    stream = RedisStream.new

    stream.add('Message 1', key: 'test-1')
    stream.add('Message 2', key: 'test-1')

    received_messages = []
    stream.each_message(key: 'test-1') do |message|
      received_messages << message
    end

    assert_equal ['Message 1', 'Message 2'], received_messages
  end
end
