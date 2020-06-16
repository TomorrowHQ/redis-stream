require "redis_stream"
require "optparse"

def parsed_options
  options = {}

  OptionParser.new do |parser|
    parser.on("-c", "--consumer=CONSUMER", "Consumer name") do |consumer|
      options[:consumer] = consumer
    end

    parser.on("-g", "--group=GROUP", "Group name") do |group|
      options[:group] = group
    end

    parser.on("-r", "--reset", "Start from the beginning") do |reset|
      options[:reset] = true
    end

    parser.on("-s", "--speed=SPEED", "Speed modifier") do |speed|
      options[:speed] = speed.to_f
    end
  end.parse!

  options
end

def clean_screen
  print "\e[2J\e[f"
end

default_options = {
  consumer: "main",
  speed: 1.0,
  group: "players",
  reset: false,
}

options = default_options.merge(parsed_options)

stream = RedisStream.stream(name: "movie")
group = RedisStream.group(name: options[:group], stream: stream)
if options[:reset]
  group.reset
end

movie = group.consumer(options[:consumer])

frame_duration = (1.0 / 16.0) * options[:speed]

movie.each do |frame|
  clean_screen
  puts frame
  sleep frame_duration
end
