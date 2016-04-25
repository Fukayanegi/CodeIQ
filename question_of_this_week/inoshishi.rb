require 'set'

DIRECTION = {:right => [1,0], :left => [-1,0], :up => [0,-1], :down => [0,1]}

def display_map map
  map.each do |line|
    puts line.join()
  end
end

n = STDIN.gets.chomp.to_i
map = []
map << ("X" * (n + 2)).each_char.to_a
n.times do
  line = "X" + STDIN.gets.chomp + "X"
  map << line.each_char.to_a
end
map << ("X" * (n + 2)).each_char.to_a

display_map map

def move pos, sym_direction
  direction = DIRECTION[sym_direction]
  # p "#{pos}"
  # p "#{direction}"
  [pos[0] + direction[1], pos[1] + direction[0]]
end

def move_val map, pos, sym_direction
  direction = DIRECTION[sym_direction]
  map[pos[0] + direction[1]][pos[1] + direction[0]]
end

def run map, start, sym_direction
  # p "#{start}, #{sym_direction}"
  current_val = map[start[0]][start[1]]
  run_result = Hash.new
  return run_result if current_val == "X"

  next_pos = move start, sym_direction
  next_val = map[next_pos[0]][next_pos[1]]

  key = [sym_direction, start]
  return run_result if @passed.include? key
  @passed << key
  
  turned = 0
  if next_val == "X"
    turned += 1
    # p "start:#{start}, direction:#{sym_direction}, turned:#{turned}"
    turned_direction1, turned_direction2 = (sym_direction == :right || sym_direction == :left) ? [:up, :down] : [:left, :right]

    run_result = run map, (move start, turned_direction1), turned_direction1
    run_result2 = run map, (move start, turned_direction2), turned_direction2
    run_result.merge!(run_result2) do |key, oldval, newval|
      oldval > newval ? newval : oldval
    end
  else
    # p "start:#{start}, direction:#{sym_direction}, turned:#{turned}"
    run_result = run map, next_pos, sym_direction
  end

  run_result.each_key do |r_key|
    run_result[r_key] += turned
  end
  run_result[start] = 0

  @passed.delete key
  return run_result
end

@passed = Set.new
max = 0
(1..n).each do |row|
  (1..n).each do |col|
    start = [row, col]
    run_result = Hash.new

    DIRECTION.each_key do |direction|
      run_result_tmp = ((move_val map, start, direction) != "X" ? (run map, start, direction) : Hash.new)
      # p run_result_tmp
      run_result_tmp.each do |key, val|
        run_result[key] = val if (run_result[key].nil? || run_result[key] > val)
      end
    end

    run_result.delete start
    # p "#{start}"
    # p run_result
    max_tmp = run_result.inject(0){|max, (key, value)| max > value ? max : value}
    max = max_tmp if max_tmp > max
  end
end
# p @result
p max