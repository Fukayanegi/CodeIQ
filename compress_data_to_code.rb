@rows = 5
@one = "#"
input = []
output = ""
@rows.times do
  input << STDIN.gets.chomp
end

input.join.each_byte{|c| output << (c.ord == @one.ord ? "1" : "0")}
puts output.to_i(2).to_s(36)