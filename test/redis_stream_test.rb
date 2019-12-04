require 'test_helper'

describe RedisStream do
  before(:each) do
    @stream = RedisStream.new
    @stream.clear(key: 'test-1')
    @stream.clear(key: 'test-2')
  end

  it 'defines a version' do
    refute_nil ::RedisStream::VERSION
  end

  it 'puts messages in redis stream' do
    @stream.add('Message', key: 'test-1')
    assert_equal 1, @stream.len(key: 'test-1')
    assert_equal 0, @stream.len(key: 'test-2')

    @stream.add('Message', key: 'test-2')
    @stream.add('Message', key: 'test-2')
    assert_equal 2, @stream.len(key: 'test-2')
    assert_equal 1, @stream.len(key: 'test-1')
  end

  it 'reads messages from the begining of stream' do
    @stream.add('Message 1', key: 'test-1')
    @stream.add('Message 2', key: 'test-1')

    received_messages = []
    @stream.each_message(key: 'test-1') do |message|
      received_messages << message
    end

    assert_equal ['Message 1', 'Message 2'], received_messages
  end

  it 'gets all entries from straem' do
    @stream.add('Entry 1', key: 'test-1')
    @stream.add('Entry 2', key: 'test-1')
    @stream.add('Entry 3', key: 'test-1')

    messages = @stream.all(key: 'test-1')
    assert_equal ['Entry 1', 'Entry 2', 'Entry 3'], messages
  end
end
