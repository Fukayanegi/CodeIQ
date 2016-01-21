c_stations, start, destination = STDIN.gets.chomp.split(',').map{|value| value.to_i}

# p "#{c_stations}, #{start}, #{destination}"

direction = start < destination ? 1 : -1
stopped = Array.new(c_stations) {0}

def move stopped, direction, destination
  0
end

puts move stopped, direction, destination