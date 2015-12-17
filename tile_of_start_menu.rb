SIZES = {A:1, B:4, C:8, D:16}
A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]
MEMO = {}

def p_map maps
  maps.each do |map|
    map.each do |row|
      p row
    end
    p '*' * 20
  end
end

def solve width, height
  patterns = solve_improve Array.new(height) {Array.new(width, 0)}, [:D, :C, :B, :A]
  #p_map patterns.uniq
  patterns.uniq
end

def solve_improve pattern_map, choices
  key = "#{pattern_map.length}*#{pattern_map[0].length}"
  return MEMO[key] if MEMO.include? key

  solution = []
  first_choice = choices[0]
  tile = eval(first_choice.to_s)

  if first_choice == :A then
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pattern_map[i][j] = :A
      end
    end
    solution << pattern_map
  elsif put? pattern_map, 0, 0, tile
    pm_dup = Marshal.load(Marshal.dump(pattern_map))
    put pm_dup, 0, 0, tile, first_choice

    if tile.length == pm_dup.length && 
      tile[0].length == pm_dup[0].length
      solution << pm_dup
    else
      if pm_dup.length > tile.length
        solution.concat (solve_with_vertical_divide pm_dup, pm_dup[0].length, tile.length, choices).uniq
        pm_dup_2 = Marshal.load(Marshal.dump(pattern_map))
        solution.concat (solve_with_vertical_divide pm_dup_2, pm_dup_2[0].length, 1, choices).uniq
      else
        solution.concat (solve_with_horizonal_divide pm_dup, tile[0].length, tile.length, choices).uniq
        pm_dup_2 = Marshal.load(Marshal.dump(pattern_map))
        solution.concat (solve_with_horizonal_divide pm_dup_2, 1, tile.length, choices).uniq
      end

    end
  end

  choices.shift
  if choices.length > 0 then
    solution.concat (solve_improve pattern_map, choices).uniq
  end

  MEMO[key] = solution if !MEMO.include? key && first_choice == :D
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

def solve_with_vertical_divide pattern_map, width, height, choices
  solution = []
  pattern_map_above = divide pattern_map, width, height
  sol_above = solve_improve pattern_map_above, choices.dup
  sol_beneath = solve_improve pattern_map, choices.dup

  sol_above.each do |matrix_v|
    sol_beneath.each do |matrix_b|
      solution << (union matrix_v, matrix_b)
    end
  end

  solution
end

def solve_with_horizonal_divide pattern_map, width, height, choices
  solution = []
  pattern_map_left = divide pattern_map, width, height
  sel_left = solve_improve pattern_map_left, choices.dup
  sol_right = solve_improve pattern_map, choices.dup

  sel_left.each do |matrix_v|
    sol_right.each do |matrix_b|
      solution << (join matrix_v, matrix_b)
    end
  end

  solution
end

def divide pattern_map, width, height
  splited_map = Array.new(height) {Array.new(width, 0)}
  height.times do |i|
    width.times do |j|
      pattern_map[i].shift
    end
  end
    
  height.times do 
    pattern_map.shift if pattern_map[0] == []
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
  pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))
  tile.each do |row|
    pattern_map_dup << row
  end
  pattern_map_dup
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
