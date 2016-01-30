base_row = "a".ord
base_col = "A".ord
c_row = "z".ord - base_row + 1
c_col = "Z".ord - base_col + 1

position = STDIN.gets.chomp!
row , col = position[0].ord - base_row, position[1].ord - base_col

table = [] << Array.new(c_col) { 0 }

c_row.times do |row|
  row_tmp = [1]
  first = 0
  second = 1
  (c_col-1).times do |col|
    first, second = second, (first + second + table[-1][col+1])
    row_tmp << second
  end
  table << row_tmp
end

puts table[row+1][col]