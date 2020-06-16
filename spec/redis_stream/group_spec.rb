require "spec_helper"

RSpec.describe RedisStream::Group do
  after(:each) do
    Redis.current.xgroup(:destroy, "test-stream", "test-group")
    Redis.current.xtrim("test-stream", 0)
  end

  describe "#stream" do
    it "returns a stream" do
      stream = RedisStream::Stream.new(name: "test-stream")
      group = RedisStream::Group.new(name: "test-group", stream: stream)

      expect(group.stream).to be_a(RedisStream::Stream)
    end
  end

  describe "#consumer" do
    it "return a consumer" do
      stream = RedisStream::Stream.new(name: "test-stream")
      group = RedisStream::Group.new(name: "test-group", stream: stream)

      expect(group.consumer("consumer")).to be_kind_of(RedisStream::Consumer)
    end
  end

  describe "#reset" do
    it "resets group to the begining of the stream" do
      stream = RedisStream::Stream.new(name: "test-stream")
      group = RedisStream::Group.new(name: "test-group", stream: stream)
      consumer = group.consumer("consumer")

      stream << 1
      expect(consumer.to_a).to eq([1])
      expect(consumer.to_a).to eq([])

      group.reset
      expect(consumer.to_a).to eq([1])
    end

    it "returns self" do
      stream = RedisStream::Stream.new(name: "test-stream")
      group = RedisStream::Group.new(name: "test-group", stream: stream)

      expect(group.reset).to eq(group)
    end
  end
end
