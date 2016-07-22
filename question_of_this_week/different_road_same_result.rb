input = STDIN.gets.chomp
p "#{input}"

board = ["#S#"]
input.each_char do |c|
  if c == "U"
    board.unshift board[0].dup if 
    board.each_with_index do |line, i|

    end
  end
  if c == "R"
    board.each_with_index do |line, i|
      board.replace("S#", ".S#") if i == 0
      board.replace(".#", ".##") if i != 0
    end
  end
  if c == "D"
    board.each_with_index do |line, i|
      board.replace(".#", "..#") if i == 0
      board.replace(".#", ".##") if i != 0
    end
  end
  if c == "L"
    board.each_with_index do |line, i|
      board.replace("#S", "#S.") if i == 0
      board.replace("#.", "##.") if i != 0
    end
  end
end