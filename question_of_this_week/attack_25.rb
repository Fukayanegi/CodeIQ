input = Hash.new
while line = STDIN.gets do
  tmp = line.chomp.split(",")
  input[tmp[0]] = tmp[1..-1] 
end

p input