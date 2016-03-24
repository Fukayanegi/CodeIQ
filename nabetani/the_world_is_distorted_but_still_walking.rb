# 行*列の二次元配列のため、
# 右方向へ進む場合 : map[row][col] → map[row + 0][col + 1]
# 下方向へ進む場合 : map[row][col] → map[row + 1][col + 0]
# 左方向へ進む場合 : map[row][col] → map[row + 0][col - 1]
# 上方向へ進む場合 : map[row][col] → map[row - 1][col + 0]
DIRECTION = [[0,1],[1,0],[0,-1],[-1,0]]

def display world
  world.each do |row|
    p row.map {|col| col.value}
  end
end

class CellValue
  attr_accessor :value, :x, :y, :direction
  def initialize
    @value = "*"
    @x = 0
    @y = 0
    @direction = 0
  end
end

@world = Array.new(12) do |world_i|
  Array.new(12) do |world_j|
    tmp = CellValue.new
    if world_i > 7 && world_j == 4
      tmp.x = 7 - (11 - world_i)
      tmp.y = -3 + 10 - world_i
      tmp.direction = -1
    elsif world_i == 8 && world_j > 7
      tmp.x = -7 + 10 - world_j
      tmp.y = 3 - (11 - world_j)
      tmp.direction = 1
      # p tmp
    end
    tmp
  end
end
values1 = ("0".."9").to_a
values1.concat ("a".."k").to_a
values1.each_with_index do |value, i|
  row = i % 3 + 1
  col = i / 3 + 1
  @world[row][col].value = value
end
values2 = ("l".."z").to_a
values2.concat ("A".."F").to_a
values2.each_with_index do |value, i|
  row = i / 3 + 1
  col = 10 - i % 3
  @world[row][col].value = value
end
values3 = ("G".."Z").to_a
values3.concat ["@"]
values3.each_with_index do |value, i|
  row = 10 - i / 3
  col = i % 3 + 1
  @world[row][col].value = value
end

def progress world, step
  direction = 1
  row, col = 1, 8
  step.times do
    cell_tmp = world[row][col]
    row, col = row + cell_tmp.y, col + cell_tmp.x
    direction = direction += cell_tmp.direction
    cell = world[row][col]
    p cell.value
    row, col = row + DIRECTION[direction][0], col   + DIRECTION[direction][1]
    # p "#{row}, #{col}, #{direction}"
  end
end

display @world
progress @world, 10
