def create_target_map map_array
  height = map_array.length
  width = map_array[0].length
  target_map = Array.new(height){|i| "X" + map_array[i] + "X"}
  target_map.unshift "X" * (width + 2)
  target_map.push "X" * (width + 2)

  target_map
end

def search y, x, target_map, path_bi, from, to, restricted
  # p "call saerch: x:#{x}, y:#{y}, path_bi:#{path_bi.to_s(2)}"
  return [] if ([y, x] != from && target_map[y][x] != "." && [y, x] != to)
  return [path_bi] if [y, x] == to

  value = 1 << (6 * (y - 1) + x - 1)
  return [] if (!(path_bi & value == 0) || !(path_bi & restricted == 0))
  path_bi |= value

  answer = []
  answer.concat search(y - 1, x, target_map, path_bi, from, to, restricted)
  answer.concat search(y, x + 1, target_map, path_bi, from, to, restricted)
  answer.concat search(y + 1, x, target_map, path_bi, from, to, restricted)
  answer.concat search(y, x - 1, target_map, path_bi, from, to, restricted)
  # p answer
  answer
end

target_map = create_target_map STDIN.gets.chomp.split("/")
row, col = 0, 0
checkpoints = target_map.inject({}) do |acc, line|
  line.each_char do |c|
    if (c =~ /[\d|s|g]/)
      k = c.to_i
      k = 0 if c == "s"
      k = 10 if c == "g"
      acc[k] = [row, col]
    end
    col += 1
  end
  row +=1
  col = 0
  acc
end.sort
# target_map.each{|line| p line}

previous_routes = [0]
checkpoints.each_cons(2) do |(from, from_pos), (to, to_pos)|
  # p "#{from}, #{to}"

  all_routes = []
  previous_routes.each do |previous_route|
    next_routes = search from_pos[0], from_pos[1], target_map, 0, from_pos, to_pos, previous_route
    # p "#{previous_routes.length}, #{next_routes.length}"
    next_routes.each do |next_route|
      # p "#{"%030b" % previous_route}"
      # p "#{"%030b" % next_route}"
      if previous_route & next_route == 0
        all_routes << (previous_route | next_route)
      end
    end
  end

  previous_routes = all_routes
end

min = 30

previous_routes.each do |key|
  len = key.to_s(2).each_char.select{|c| c == "1"}.length
  if len < min
    min = len
  end
end

puts (min == 30 ? "-" : min)
