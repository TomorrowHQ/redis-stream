require "spec_helper"

RSpec.describe RedisStream do
  describe "#stream" do
    it "returns a stream object" do
      stream = RedisStream.stream(name: "stream")
      expect(stream).to be_a(RedisStream::Stream)
    end
  end

  describe "#group" do
    it "returns a group object" do
      stream = RedisStream::Stream.new(name: "stream")

      consumers = RedisStream.group(name: "consumers", stream: stream)

      expect(consumers).to be_a(RedisStream::Group)
    end
  end
end
