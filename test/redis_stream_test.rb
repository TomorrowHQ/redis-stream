require 'test_helper'

describe RedisStream do
  before do
    @client = RedisStream.new
  end

  it 'defines a version' do
    refute_nil ::RedisStream::VERSION
  end

  describe '#stream' do
    it 'returns stream' do
      stream = @client.stream('test')
      assert_kind_of RedisStream::Stream, stream
      assert_equal 'test', stream.key
    end
  end

  describe '#group' do
    it 'creates consumer group' do
      group = @client.group(key: 'test-1', name: 'testers')
      assert_kind_of RedisStream::Group, group

      same_group = @client.group(key: 'test-1', name: 'testers')
      assert_kind_of RedisStream::Group, same_group

      assert_equal group.key, same_group.key
      assert_equal group.name, same_group.name
    end
  end
end
