c_stations, start, destination = STDIN.gets.chomp.split(',').map{|value| value.to_i}

# p "#{c_stations}, #{start}, #{destination}"

direction = start < destination ? 1 : -1
stopped = Array.new(c_stations) {0}
stopped[start-1] = 1

left = direction == 1 ? destination - 2 : destination - 1
right = direction == 1 ? c_stations - destination : c_stations - destination - 1
less = left <= right ? left : right
less_d = left <= right ? -1 : 1
max_turns = ((direction == 1 && less_d == -1 && left != right) || (direction == -1 && less_d == 1&& left != right)) ? less * 2 + 1 : less * 2
# p "#{direction}, #{less_d}, #{less}"
# p "#{max_turns}"

first = direction == 1 ? right : left
second = direction == 1 ? left : right

def factorial(number)
  number = 0 if number.nil?
  (1..number).inject(1,:*)
end

patterns = 0
(0..max_turns).each do |i|
  first_c = factorial(first) / factorial(first-(i+1)/2)
  second_c = factorial(second) / factorial(second-i/2)
  # p "#{i}, #{first_c}, #{second_c}"
  patterns += first_c * second_c
end

def move stopped, direction, destination
  patterns = 0
  stopped.each_with_index do |station, i|
    # p "#{stopped}, #{direction}, #{i}"
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

# puts move stopped, direction, destination-1
puts patterns