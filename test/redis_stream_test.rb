require 'test_helper'

describe RedisStream do
  it 'defines a version' do
    refute_nil ::RedisStream::VERSION
  end
end
