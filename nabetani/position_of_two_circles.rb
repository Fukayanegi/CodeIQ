require 'scanf'

circles = STDIN.gets.chomp.split(" ").map{|p_circle| p_circle.split("/")}

def judge r1, r2, distance
  return "A" if r1 == r2 && distance == 0
  return "C" if r1 + distance == r2 || r2 + distance == r1
  return "B" if distance < r1 || distance < r2
  return "D" if distance < r1 + r2
  return "E" if distance == r1 + r2
  return "F" if distance > r1 + r2
end

answer = []
circles.each do |p_circle|
  c1 = p_circle[0].scanf("(%d,%d)%d")
  c2 = p_circle[1].scanf("(%d,%d)%d")
  distance = Math.sqrt((c2[0] - c1[0])**2 + (c2[1] - c1[1])**2)
  answer << judge(c1[2], c2[2], distance)
end

puts answer.join