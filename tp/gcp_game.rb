a = 0
b = 0

def judge a, b, hand_a, hand_b
  p "#{a}, #{b}, #{hand_a}, #{hand_b}"
  return [0,3] if hand_a == "C" && hand_b == "G"
  return [0,6] if hand_a == "P" && hand_b == "C"
  return [0,6] if hand_a == "G" && hand_b == "P"
  return [3,0] if hand_a == "G" && hand_b == "C"
  return [6,0] if hand_a == "C" && hand_b == "P"
  return [6,0] if hand_a == "P" && hand_b == "G"
  return [0,0] if a == b
  return [0,7] if a > b
  return [7,0] if a < b
end

def print_result a, b
  puts "A,#{a-b}" if a > b
  puts "B,#{b-a}" if a < b
  puts "even" if a == b
end

while line = STDIN.gets
  hand_a, hand_b = line.chomp.split(",")
  a_res, b_res = judge a, b, hand_a, hand_b
  a += a_res
  b += b_res
end

print_result a, b