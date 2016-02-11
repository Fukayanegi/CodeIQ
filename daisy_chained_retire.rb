input = Array.new(11)
11.times do |i|
  input[i] = STDIN.gets.chomp!
end

def count_menber_of_retire first_retired, members
  p first_retired
  p members
  0
end

first = input.shift
puts count_menber_of_retire first, input