A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]

def solve width, height
  usage = solve_tile_usage width * height, [[]], [:D, :C, :B, :A]
  usage.uniq
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

def solve_tile_pattern pattern_map, usage, solution
  usage.each do |tile|
    tile_matrix = eval(tile.shift)
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if put? pattern_map, i, j, tile_matrix then
          tile_matrix.each_with_index do |row, k|
            row.each_with_index do |col, l|
              pattern_map[i+k][j+l] = tile
            end
          end

          return pattern_map if usage.nil?
          ret = solve_tile_pattern pattern_map, usage.dup
          solution << ret unless ret.nil?
        else
          nil
        end
      end
    end
  end
end

def put? pattern_map, x, y, tile
  tile.each_with_index do |row, i|
    row.each_with_index do |column, j|
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

p answer_tmp
puts "OUTPUT : Patterns = " + answer.to_s

puts answer
