require 'set'

def display board
  board.each do |row|
    p row.map{|c| "%3s" % c}.join(",")
  end
end

m, n = STDIN.gets.chomp.split(",").map{|v| v.to_i}
# p "#{m}, #{n}"

# 交点の配列
# 一番側に範囲外=-1を設定
board = Array.new(n + 3) do |i_row|
  if (1..(n + 1)).include? i_row
    Array.new(m + 3) do |i_col|
      ((1..(m + 1)).include? i_col) ? 0 : -1
    end
  else
    Array.new(m + 3) {-1}
  end
end
display board

@direction_x, @direction_y = 1, -1

def move board, x, y
  next_x, next_y = x + @direction_x, y + @direction_y

  # 上下へ反射
  return next_x, next_y if board[next_y][next_x] > -1

  if next_y == 0 || next_y == board.length - 1
    @direction_y = @direction_y * -1
    next_x, next_y = next_x, next_y + @direction_y * 2
  end

  # 左右へ反射
  if next_x == 0 || next_x == board[0].length - 1
    @direction_x = @direction_x * -1
    next_x, next_y = next_x + @direction_x * 2, next_y
  end

  # p "#{@direction_x}, #{@direction_y}"
  return next_x, next_y
end

def panel x_prev, y_prev, x, y
  panel_x = x_prev < x ? x_prev : x
  pnael_y = y_prev < y ? y_prev : y
  [panel_x, pnael_y]
end

route = []
passed = Set.new
x, y = 2, 1
while true do
  p "#{x}, #{y}"
  x_prev, y_prev = x, y
  x, y = move board, x, y
  key = "#{x_prev},#{y_prev}->#{x},#{y}"
  break if route.include? key
  route << key
  passed << panel(x_prev, y_prev, x, y)
end

p passed