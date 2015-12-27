@rows = 2
@one = "#"
input = []
output = ""
@rows.times do
  input << STDIN.gets.chomp
end

input.join.each_byte{|c| output << (c.ord == @one.ord ? "1" : "0")}
puts output