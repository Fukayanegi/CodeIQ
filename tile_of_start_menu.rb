require 'set'

SIZES = {A:[1,1], B:[2,2], C:[4,2], D:[4,4]}
MEMO = {}
@miss = 0
@total = 0
A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]
# A = [1]
# B = [11, 11]
# C = [1111, 1111]
# D = [1111, 1111, 1111, 1111]

@now
@target_time = 0

def p_map maps
  maps.each do |map|
    map.each do |row|
      p row
    end
    p '*' * 20
  end
end

def p_hash hash
  hash.each do |key, val|
    p key
    p_map val
  end
end

def solve width, height
  @now = Time.now
  patterns = solve_improve width, height, [:D, :C, :B, :A], 0
  #p_hash MEMO
  #p_map patterns
  p @total
  p @miss
  p MEMO.keys
  p Time.now - @now
  p @target_time
  patterns
end

def solve_improve width, height, choices, choice
  @total += 1
  key = "#{width}*#{height}"  
  #p key
  return MEMO[key] if MEMO.include? key
  @miss += 1

  solution = Set.new
  first_choice = choices[choice]

  if first_choice == :A then
    pattern_map = Array.new(height) {Array.new(width, 0)}
    pattern_map.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pattern_map[i][j] = :A
      end
    end
    solution << pattern_map
  else
    if SIZES[first_choice][0] == width && SIZES[first_choice][1] == height
      tile = eval(first_choice.to_s)
      pattern_map = Array.new(height) {Array.new(width, 0)}
      put pattern_map, 0, 0, tile, first_choice
      solution << pattern_map
    end

    (width / 2).times do |i|
      sol_tmp = solve_with_horizonal_divide width, height, i+1, choices, choice
      sol_tmp_r = reverse sol_tmp, i+1
      # now = Time.now
      solution.merge sol_tmp
      solution.merge sol_tmp_r
      # @target_time += now - Time.now
    end

    (height / 2).times do |i|
      sol_tmp = solve_with_vertical_divide width, height, i+1, choices, choice
      sol_tmp_upd = up_to_down sol_tmp, i+1
      # now = Time.now
      solution.merge sol_tmp
      solution.merge sol_tmp_upd
      # @target_time += Time.now - now
    end
  end

  if first_choice != :A then
    sol_tmp = solve_improve width, height, choices, choice + 1
    # now = Time.now
    solution.merge sol_tmp
    # @target_time += Time.now - now
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

def solve_with_horizonal_divide map_width, map_height, width, choices, choice
  solution = Set.new
  sol_left = solve_improve width, map_height, choices, choice
  sol_right = solve_improve map_width - width, map_height, choices, choice

  sol_left.each do |matrix_v|
    sol_right.each do |matrix_b|
      sol_tmp = join matrix_v, matrix_b
      now = Time.now
      solution << sol_tmp
      @target_time += Time.now - now
    end
  end

  solution
end

def solve_with_vertical_divide map_width, map_height, height, choices, choice
  solution = Set.new
  sol_above = solve_improve map_width, height, choices, choice
  sol_beneath = solve_improve map_width, map_height - height, choices, choice

  sol_above.each do |matrix_v|
    sol_beneath.each do |matrix_b|
      sol_tmp = union matrix_v, matrix_b
      now = Time.now
      solution << sol_tmp
      @target_time += Time.now - now
    end
  end

  solution
end

def join pattern_map, tile
  # now = Time.now
  pm_dup = Marshal.load(Marshal.dump(pattern_map))
  # @target_time += Time.now - now
  tile.each_with_index do |row, i|
    row.each do |column|
      pm_dup[i] << column
    end
  end
  pm_dup
end

def union pattern_map, tile
  # now = Time.now
  pm_dup = Marshal.load(Marshal.dump(pattern_map))
  # @target_time += Time.now - now
  tile.each do |row|
    pm_dup << row
  end
  pm_dup
end

def reverse solution, baseline
  sol_tmp = Set.new
  solution.each do |pattern_map|
    # now = Time.now
    pm_dup = Marshal.load(Marshal.dump(pattern_map))
    # @target_time += Time.now - now
    pm_dup.each do |row|
      baseline.times do
        tmp = row.shift
        row << tmp
      end
    end
    sol_tmp << pm_dup
  end
  sol_tmp
end

def up_to_down solution, baseline
  sol_tmp = Set.new
  solution.each do |pattern_map|
    # now = Time.now
    pm_dup = Marshal.load(Marshal.dump(pattern_map))
    # @target_time += Time.now - now
    baseline.times do
      tmp = pm_dup.shift
      pm_dup << tmp
    end
    sol_tmp << pm_dup
  end
  sol_tmp
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
