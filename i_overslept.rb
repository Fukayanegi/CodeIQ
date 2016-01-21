c_stations, start, destination = STDIN.gets.chomp.split(',').map{|value| value.to_i}

# p "#{c_stations}, #{start}, #{destination}"

direction = start < destination ? 1 : -1
stopped = Array.new(c_stations) {0}
stopped[start-1] = 1

def move stopped, direction, destination
  patterns = 0
  stopped.each_with_index do |station, i|
    patterns += 1 if i == destination
    overslept = (direction == 1 && destination < i && station == 0)
    overslept = overslept || (direction == -1 && destination > i && station == 0)
    if overslept
      stopped[i] = 1
      patterns += move stopped, -1*direction, destination
      stopped[i] = 0
    end
  end
  return patterns
end

puts move stopped, direction, destination-1