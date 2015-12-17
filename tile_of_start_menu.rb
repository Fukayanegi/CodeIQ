SIZES = {A:1, B:4, C:8, D:16}
A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]

def solve width, height
  patterns = solve_improve Array.new(height) {Array.new(width, 0)}, [:D, :C, :B, :A]
  p patterns.uniq
  patterns.uniq
end

def solve_improve pattern_map, choices
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
    pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))
    put pattern_map_dup, 0, 0, tile, first_choice

    if tile.length == pattern_map_dup.length && 
      tile[0].length == pattern_map_dup[0].length
      solution << pattern_map_dup
    else
      if pattern_map_dup.length > tile.length
        divide_map_vertical = divide pattern_map_dup, pattern_map_dup[0].length, tile.length
        # p divide_map_vertical
        # p pattern_map_dup
        solution_temp_above = solve_improve divide_map_vertical, choices.dup
        solution_temp_beneath = solve_improve pattern_map_dup, choices.dup

        solution_temp_above.each do |matrix_v|
          solution_temp_beneath.each do |matrix_b|
            solution << (union matrix_v, matrix_b)
          end
        end

        pattern_map_dup_2 = Marshal.load(Marshal.dump(pattern_map))
        divide_map_vertical_2 = divide pattern_map_dup_2, pattern_map_dup_2[0].length, 1
        solution_temp_above_2 = solve_improve divide_map_vertical_2, choices.dup
        solution_temp_beneath_2 = solve_improve pattern_map_dup_2, choices.dup

        solution_temp_above_2.each do |matrix_v|
          solution_temp_beneath_2.each do |matrix_b|
            solution << (union matrix_v, matrix_b)
          end
        end

      else
        divide_map = divide pattern_map_dup, tile[0].length, tile.length
        solution_temp1 = solve_improve divide_map, choices.dup
        solution_temp2 = solve_improve pattern_map_dup, choices.dup
        solution_temp1.each do |matrix_1|
          solution_temp2.each do |matrix_2|
            solution << (join matrix_1, matrix_2)
          end
        end

        pattern_map_dup_2 = Marshal.load(Marshal.dump(pattern_map))
        divide_map_2 = divide pattern_map_dup_2, 1, tile.length
        solution_temp1_2 = solve_improve divide_map_2, choices.dup
        solution_temp2_2 = solve_improve pattern_map_dup_2, choices.dup
        solution_temp1_2.each do |matrix_1|
          solution_temp2_2.each do |matrix_2|
            solution << (join matrix_1, matrix_2)
          end
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
