require "redis_stream"

Frame = Struct.new(:duration, :data)

def load_frames(path)
  File.readlines(path)
      .each_slice(14)
      .to_a
      .map { |chunk| Frame.new(chunk[0].to_i, chunk[1...13]) }
end

frames = load_frames("./examples/movie/frames.txt")

movie = RedisStream.stream(name: "movie")
movie.clear

frames.each do |frame|
  frame.duration.times do
    movie << frame.data
  end
end
