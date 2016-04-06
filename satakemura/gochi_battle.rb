target = STDIN.gets.chomp
menu = []
while line = STDIN.gets do
  menu << line.chomp
end

p "target: #{target}"
p menu