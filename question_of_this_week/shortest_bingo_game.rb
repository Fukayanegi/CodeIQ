cards = []
while line = STDIN.gets do
  cards << line.chomp.split(",")
end

p cards