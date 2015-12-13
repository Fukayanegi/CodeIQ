A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]

def solve width, height
  usages = solve_tile_usage width * height, [[]], [:D, :C, :B, :A]
  patterns = solve_tile_pattern Array.new(height) {Array.new(width, 0)}, usages.uniq
  patterns.uniq
end

def solve_tile_usage size, usages, choice
  first_choice = choice[0]
  usage = usages[usages.size-1]
  usage_dup = usage.dup
  tile = eval(first_choice.to_s)
  t_size = tile.inject(0) {|sum, array| sum += array.inject(:+)}
#  puts "#{size}, #{t_size}, #{tile}"

  if size >= t_size
    usage << first_choice
    solve_tile_usage size - t_size, usages, choice.dup
  end

  choice.shift
  if choice.length > 0 then
    usages << usage_dup if usage != []
    solve_tile_usage size, usages, choice
  end
  
  usages
end

def solve_tile_pattern pattern_map, usages
  solution = []
  usages.each do |tiles|
    temp = (solve_tile_pattern_by_usage Marshal.load(Marshal.dump(pattern_map)), tiles, [])
    p temp
    solution.concat temp
  end
  return solution
end

def solve_tile_pattern_by_usage pattern_map, tiles, solution
  if tiles.uniq.count == 1 && tiles[0] == :A then
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pattern_map[i][j] = :A if column == 0
      end
    end
    solution << pattern_map
  else
    tile = tiles.shift
    tile_matrix = eval(tile.to_s)

    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if put? pattern_map, i, j, tile_matrix then
          pattern_map_dup = Marshal.load(Marshal.dump(pattern_map))
          tile_matrix.each_with_index do |row, k|
            row.each_with_index do |col, l|
              pattern_map_dup[i+k][j+l] = tile
            end
          end

          if tiles.length == 0 then
            solution << pattern_map_dup
          else
            solve_tile_pattern_by_usage pattern_map_dup, tiles.dup, solution
          end
        else
          nil
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

size = STDIN.gets
if size.nil?
  puts "Warning size must not be nil"
  exit 0
end

width, height = size.split(',')
puts "INPUT : Width = #{width}, Height = #{height}"
begin
  width, height = Integer(width), Integer(height)
rescue
  puts "Warning : Width or Height is not a number"
  width, height = 0, 0
end

answer_tmp = solve width, height
answer = answer_tmp.count

#p answer_tmp
puts "OUTPUT : Patterns = " + answer.to_s

puts answer
