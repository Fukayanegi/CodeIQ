# FIXME: いろんな固定値をハードコードしている

# 行*列の二次元配列のため、
# 右方向へ進む場合 : map[row][col] → map[row + 0][col + 1]
# 下方向へ進む場合 : map[row][col] → map[row + 1][col + 0]
# 左方向へ進む場合 : map[row][col] → map[row + 0][col - 1]
# 上方向へ進む場合 : map[row][col] → map[row - 1][col + 0]
DIRECTION = [[0,1],[1,0],[0,-1],[-1,0]]

class CellValue
  attr_accessor :value, :x, :y, :direction
  def initialize
    @value = "!"
    @x = 0          # 実体値のある相対x座標 
    @y = 0          # 実体値のある相対y座標 
    @direction = 0  # 実体値に移動した際の方向転換
  end
end

class Solver
  # デバッグ用
  def display_world
    @world.each do |row|
      p row.map {|col| col.value}
    end
  end

  def initialize
    create_world
    # display_world
  end

  def create_world
    @world = Array.new(12) do |world_i|
      Array.new(12) do |world_j|
        tmp = CellValue.new
        # 奈落だけど、実体の値は相対的な位置にあること（歪んだ世界）を表現
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
    # FIXME: 何かもっとうまい定義方法があるのでは
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
  end

  def turn direction, turn
      direction = direction += turn
      direction = 3 if direction == -1
      direction = 0 if direction == 4
      direction
  end

  def progress start_pos, direction, step
    row, col = start_pos
    step.times do
      row, col = row + DIRECTION[direction][0], col + DIRECTION[direction][1]
      cell_tmp = @world[row][col]
      direction = turn direction, cell_tmp.direction
      row, col = row + cell_tmp.y, col + cell_tmp.x
      cell = @world[row][col]
      print cell.value
      break if cell.value == "!"
    end
    [[row, col], direction]
  end

  def solve command, start_pos = [1, 1], start_direction = 0
    pos = start_pos
    direction = start_direction
    print @world[pos[0]][pos[1]].value
    command.each_char do |c|
      if c == "R"
        direction = turn direction, 1
      elsif c == "L"
        direction = turn direction, -1
      elsif
        ret = progress(pos, direction, c.to_i)
        pos, direction = ret
        break if @world[pos[0]][pos[1]].value == "!"
      end
    end
    puts
  end
end

command = STDIN.gets.chomp
solver = Solver.new
# solver.solve "1R1", [9, 3], 0
# solver.solve "1", [1, 1], 0
# solver.solve "5R1R2L1"
# solver.solve "3R2"
solver.solve command
