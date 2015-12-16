SIZES = {A:1, B:4, C:8, D:16}
A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]

def solve width, height
  patterns = solve_improve Array.new(height) {Array.new(width, 0)}, [:D, :C, :B, :A]
  p patterns.uniq
  patterns.uniq
  # usages = solve_tile_usage width * height, [], [:D, :C, :B, :A]
  # patterns = solve_tile_pattern Array.new(height) {Array.new(width, 0)}, usages.uniq
  # patterns.uniq
end

def solve_improve pattern_map, choices
  solution = []
  first_choice = choices[0]
  tile = eval(first_choice.to_s)
  p first_choice

  if first_choice == :A then
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pattern_map[i][j] = :A
      end
    end
    solution << pattern_map
  elsif put? pattern_map, 0, 0, tile
    pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))
    put pattern_map_dup, 0, 0, tile, first_choice

    if tile.length == pattern_map_dup.length && 
      tile[0].length == pattern_map_dup[0].length
      solution << pattern_map_dup
    else
      divide_map = divide pattern_map_dup, tile[0].length, tile.length
      solution_temp1 = solve_improve divide_map, choices.dup
      solution_temp2 = solve_improve pattern_map_dup, choices.dup
      solution_temp1.each do |matrix_1|
        solution_temp2.each do |matrix_2|
          solution << (join matrix_1, matrix_2)
        end
      end
      p solution

      pattern_map_dup_2 = Marshal.load(Marshal.dump(pattern_map))
      divide_map_2 = divide pattern_map_dup_2, 1, tile[0].length
      solution_temp1_2 = solve_improve divide_map_2, choices.dup
      solution_temp2_2 = solve_improve pattern_map_dup_2, choices.dup
      p solution_temp1_2 
      p solution_temp2_2 
      solution_temp1_2.each do |matrix_1|
        solution_temp2_2.each do |matrix_2|
          solution << (join matrix_1, matrix_2)
        end
      end
    end
  end

  choices.shift
  if choices.length > 0 then
    solution.concat (solve_improve pattern_map, choices)
  end
  return solution
end

def solve_tile_usage size, usage, choice
  first_choice = choice[0]
  next_usage = usage.dup
  t_size = SIZES[first_choice]
  ret_usage = []

  if size >= t_size
    next_usage << first_choice
    ret = solve_tile_usage size - t_size, next_usage, choice.dup
    ret_usage.concat ret if ret != []
  end

  choice.shift
  if choice.length > 0 then
    ret = solve_tile_usage size, usage, choice
    ret_usage.concat ret if ret != []
  else
    ret_usage << usage if size == 0
  end
  
  ret_usage
end

def solve_tile_pattern pattern_map, usages
  solution = []
  usages.each do |tiles|
    temp = (solve_tile_pattern_by_usage Marshal.load(Marshal.dump(pattern_map)), tiles)
    solution.concat temp
  end
  return solution
end

def solve_tile_pattern_by_usage pattern_map, tiles
  solution = []
  p tiles

  if tiles.uniq.count == 1 && tiles[0] == :A then
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pattern_map[i][j] = :A if column == 0
      end
    end
    solution << pattern_map
  elsif tiles.uniq.count == 1
    tiles.each do |tile|
      tile_matrix = eval(tile.to_s)
      pattern_map.each_with_index do |row, i|
        row.each_with_index do |cpl, j|
          if put? pattern_map, i, j, tile_matrix then
            tile_matrix.each_with_index do |t_row, k|
              t_row.each_with_index do |t_col, l|
                pattern_map[i+k][j+l] = tile
              end
            end
          end
        end
      end
    end

    invalid = pattern_map.inject(0) do |sum, row| 
      sum += row.inject(0) do |sum, col|
        sum += 1 if col.class != Symbol
        sum
      end
    end
    solution << pattern_map if invalid == 0
  else
    tile = tiles.shift
    tile_matrix = eval(tile.to_s)

    pattern_map.each_with_index do |row, i|
      row.each_with_index do |cpl, j|
        if put? pattern_map, i, j, tile_matrix then
          pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))

          tile_matrix.each_with_index do |t_row, k|
            t_row.each_with_index do |t_col, l|
              pattern_map_dup[i+k][j+l] = tile
            end
          end

          if tiles.length == 0 then
            solution << pattern_map_dup
          else
            ret = solve_tile_pattern_by_usage pattern_map_dup, tiles.dup
            solution << ret if ret != []
          end
        end
      end
    end
  end

  return solution
end

def put? pattern_map, x, y, tile
  tile.each_with_index do |row, i|
    row.each_with_index do |column, j|
      return false if (pattern_map.length <= x + i || pattern_map[0].length <= y + j)
      return false if pattern_map[x+i][y+j] != 0
    end
  end
  return true
end

def put pattern_map, x, y, tile, sym
  tile.each_with_index do |row, i|
    row.each_with_index do |column, j|
      pattern_map[x+i][y+j] = sym
    end
  end
end

def divide pattern_map, width, height
  splited_map = Array.new(height) {Array.new(width, 0)}
  height.times do |i|
    width.times do |j|
      pattern_map[i].shift
    end
  end
  splited_map
end

def join pattern_map, tile
  pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))
  tile.each_with_index do |row, i|
    row.each do |column|
      pattern_map_dup[i] << column
    end
  end
  pattern_map_dup
end

def union pattern_map, tile
  tile.each do |row|
    pattern_map << row
  end
end

size = STDIN.gets
if size.nil?
  puts "Warning size must not be nil"
  exit 0
end

width, height = size.split(',')
#puts "INPUT : Width = #{width}, Height = #{height}"
begin
  width, height = Integer(width), Integer(height)
rescue
  puts "Warning : Width or Height is not a number"
  width, height = 0, 0
end

answer_tmp = solve width, height
answer = answer_tmp.count

#p answer_tmp
#puts "OUTPUT : Patterns = " + answer.to_s

puts answer
