def show_board board
  board.each do |line|
    puts line.join
  end
end

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
board = []
m.times do
  board << STDIN.gets.chomp.each_char.to_a
end

show_board board