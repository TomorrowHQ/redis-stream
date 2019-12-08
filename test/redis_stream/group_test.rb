require 'test_helper'

describe RedisStream::Group do
  before do
    @redis = Redis.new
    @group = RedisStream::Group.new(
      redis: @redis,
      key: 'group-test',
      name: 'group-testers'
    )

    begin
      @redis.xgroup(:destroy, @group.key, @group.name)
      @redis.del(@group.key)
    rescue
      nil
    end
  end

  describe '#create' do
    it 'returns self' do
      assert_equal @group, @group.create
    end

    it 'creates a stream' do
      @group.create
      assert @redis.exists(@group.key)
    end

    it 'creates a group that starts from begining' do
      @group.create
      info = @redis.xinfo(:groups, @group.key).first

      assert_equal @group.name, info['name']
      assert_equal '0-0', info['last-delivered-id']
    end
  end

  describe '#destroy' do
    before { @group.create }

    it 'returns self' do
      assert_equal @group, @group.destroy
    end

    it 'destroys a group' do
      @group.destroy

      assert_equal [], @redis.xinfo(:groups, @group.key)
    end
  end

  describe '#info' do
    before do
      @group_2 = RedisStream::Group.new(
        redis: @redis,
        key: 'group-test',
        name: 'group-testers-2'
      )
      @group_2.create
    end
    after { @group_2.destroy }

    it 'returns information about group' do
      assert_nil @group.info

      @group.create
      expected_info = {
        'name' => @group.name,
        'consumers' => 0,
        'pending' => 0,
        'last-delivered-id' => '0-0'
      }
      assert_equal expected_info, @group.info

      @group.destroy
      assert_nil @group.info
    end
  end

  describe 'each_message' do
    it 'reads messages from stream' do
      stream = RedisStream::Stream.new(key: 'group-test', redis: @redis)
      @group.create

      stream.add('Message 1')
      stream.add('Message 2')

      received_messages = []
      @group.each_message do |message|
        received_messages << message
      end

      assert_equal ['Message 1', 'Message 2'], received_messages
    end
  end
end
