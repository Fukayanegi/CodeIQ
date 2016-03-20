def display_panel panel
  panel.each do |line|
    p line
  end
end

@panel = Array.new(7) {Array.new(7) {0}}

input = Hash.new
while line = STDIN.gets do
  tmp = line.chomp.split(",")
  input[tmp[0]] = tmp[1..-1] 
end

p input
display_panel @panel