require "spec_helper"

RSpec.describe RedisStream::Consumer do
  after(:each) do
    Redis.current.xgroup(:destroy, "stream", "group")
    Redis.current.xtrim("stream", 0)
    Redis.current.del("stream")
  end

  it "consumes messages from the stream" do
    stream = RedisStream::Stream.new(name: "stream")
    group = RedisStream::Group.new(name: "group", stream: stream)
    consumer = RedisStream::Consumer.new(
      name: "consumer", group: group, stream: stream)

    stream << 1 << 2
    expect(consumer.to_a).to eq([1, 2])
    expect(consumer.to_a).to eq([])

    stream << 3 << 4
    expect(consumer.to_a).to eq([3, 4])
    expect(consumer.to_a).to eq([])
  end
end
