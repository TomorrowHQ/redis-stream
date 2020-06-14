require "spec_helper"

RSpec.describe RedisStream::Stream do
  after(:each) do
    Redis.current.xtrim("test-stream", 0)
  end

  it "implements Enumerable" do
    stream = RedisStream::Stream.new(name: "test-stream")

    stream << 1
    stream << 2
    stream.push(3)

    expect(stream.to_a).to eq([1, 2, 3])
    expect(stream.max).to eq(3)
    expect(stream.min).to eq(1)
    expect(stream.first).to eq(1)
    expect(stream).to include(2)
    expect(stream.reduce(:+)).to eq(6)
    expect(stream.map { |i| i * i }).to eq([1, 4, 9])
  end

  it "marshals different types" do
    stream = RedisStream::Stream.new(name: "test-stream")
    stream << { a: 1, b: "2" }
    expect(stream.first).to eq(a: 1, b: "2")
  end

  it "can be cleared" do
    stream = RedisStream::Stream.new(name: "test-stream")
    stream << 1
    expect(stream.to_a).not_to be_empty

    stream.clear
    expect(stream.to_a).to be_empty
  end

  describe "#last" do
    it "returns last item on the stream" do
      stream = RedisStream::Stream.new(name: "test-stream")
      stream << 1

      expect(stream.last).to eq(1)
      expect(stream.last(2)).to eq([1])

      stream << 2 << 3

      expect(stream.last).to eq(3)
      expect(stream.last(2)).to eq([2, 3])
    end
  end

  describe "#length" do
    it "returns size of the stream" do
      stream = RedisStream::Stream.new(name: "test-stream")
      stream << 1 << 2 << 3

      expect(stream.length).to eq(3)
    end
  end

  describe "#size" do
    it "returns size of the stream" do
      stream = RedisStream::Stream.new(name: "test-stream")
      stream << 1 << 2 << 3

      expect(stream.size).to eq(3)
    end
  end
end
