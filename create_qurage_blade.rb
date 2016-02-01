c_qurage = STDIN.gets.chomp!.to_i
s_qurage = STDIN.gets.chomp!

items = Array.new(3)

c_q = s_qurage.count "q"
c_Q = c_qurage - c_q

items = (c_q * 2 + c_Q * 8) / 5, (c_q * 10 + c_Q * 2) / 6, (c_q * 2 + c_Q * 2) / 2

puts items.min