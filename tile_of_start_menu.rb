require 'set'

SIZES = {A:[1,1], B:[2,2], C:[4,2], D:[4,4]}
MEMO = {}
@miss = 0
@total = 0
A = [1]
B = [22, 22]
C = [3333, 3333]
D = [4444, 4444, 4444, 4444]

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
  p_map patterns
  # p @total
  # p @miss
  p Time.now - @now
  # p @target_time
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
    pattern_map = Array.new(height)
    pattern_map.each_with_index do |row, i|
      pattern_map[i] = Integer('1' * width)
    end
    solution << pattern_map
  else
    if SIZES[first_choice][0] == width && SIZES[first_choice][1] == height
      pattern_map = eval(first_choice.to_s)
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

def join left, right
  # now = Time.now
  pm_dup = Marshal.load(Marshal.dump(left))
  # @target_time += Time.now - now
  right.each_with_index do |row, i|
    pm_dup[i] = pm_dup[i] * 10 ** (Math.log10(row + 1).ceil) + row
  end
  pm_dup
end

def union above, beneath
  # now = Time.now
  pm_dup = Marshal.load(Marshal.dump(above))
  # @target_time += Time.now - now
  beneath.each do |row|
    pm_dup << row
  end
  pm_dup
end

def reverse solution, baseline
  sol_tmp = Set.new
  solution.each do |pattern_map|
    # now = Time.now
    pm_rev = Array.new
    # @target_time += Time.now - now
    pattern_map.each do |row|
      left = row / 10**(Math.log10(row + 1).ceil - baseline)
      right = row % 10**(Math.log10(row + 1).ceil - baseline)

      pm_rev << right * 10**baseline + left
    end
    sol_tmp << pm_rev
  end
  sol_tmp
end

def up_to_down solution, baseline
  sol_tmp = Set.new
  solution.each do |pattern_map|
    # now = Time.now
    pm_upd = Marshal.load(Marshal.dump(pattern_map))
    # @target_time += Time.now - now
    baseline.times do |i|
      tmp = pm_upd.shift
      pm_upd << tmp
    end
    sol_tmp << pm_upd
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
