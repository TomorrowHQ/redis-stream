require "redis_stream"

def clean_screen
  print "\e[2J\e[f"
end

movie = RedisStream.stream(name: "movie")

frame_duration = 1.0 / 16.0
movie.each do |frame|
  clean_screen
  puts frame
  sleep frame_duration
end
