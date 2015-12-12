def solve
  [{A:0, B:0, C:0, D:0}]
end

n = STDIN.gets
if n.nil?
#  puts "Warning N must not be nil"
  exit 0
end

answer_tmp = solve
answer = answer_tmp.count

#puts "OUTPUT : P = " + answer.to_s

puts answer
