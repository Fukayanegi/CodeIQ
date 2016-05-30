require 'set'

ROW = 3
COL = 4
GOAL = [ROW,COL]
FILTER = {[-1,0]=>11, [0,1]=>7, [1,0]=>14, [0,-1]=>13}
BLOCK_FROM = {[-1,0]=>1, [0,1]=>2, [1,0]=>4, [0,-1]=>8}
BLOCK_TO = {[-1,0]=>4, [0,1]=>8, [1,0]=>1, [0,-1]=>2}
@vertex = [[9,1,1,1,3], [8,0,0,0,2], [8,0,0,0,2], [12,4,4,4,6]]

n = STDIN.gets.chomp.to_i
@path = Array.new
@calls = 0

def check_vertex pos
  cant_use = Hash.new
  vertex = @vertex[pos[0]][pos[1]]
  return cant_use if vertex == 15
  if vertex | 1 == 15 
    cant_use[pos] = 1
    cant_use[[pos[0]-1,pos[1]]] = 4
  elsif vertex | 2 == 15
    cant_use[pos] = 2
    cant_use[[pos[0],pos[1]+1]] = 8
  elsif vertex | 4 == 15
    cant_use[pos] = 4
    cant_use[[pos[0]+1,pos[1]]] = 1
  elsif vertex | 8 == 15
    cant_use[pos] = 8
    cant_use[[pos[0],pos[1]-1]] = 2
  end
  cant_use
end

def record_path_and_move pos, direction, n, passed
  if passed == 0
    g_from_x = (n.even? && direction == [1, 0]) || (n.odd? && direction == [0, 1]) ? [ROW, COL-1] : [ROW-1, COL]
    g_direction_x = (n.even? && direction == [1, 0]) || (n.odd? && direction == [0, 1]) ? [0, 1] : [1, 0]
    @vertex[g_from_x[0]][g_from_x[1]] |= BLOCK_FROM[g_direction_x]
    @vertex[ROW][COL] |= BLOCK_TO[g_direction_x]
  end
  @calls += 1
  pos_next = [pos[0] + direction[0], pos[1] + direction[1]]
  pos_x, pos_y = pos[0], pos[1]
  pos_next_x, pos_next_y = pos_next[0], pos_next[1]

  return 0 if n < 0 && pos_next != GOAL
  return 0 if pos_next_x < 0 || pos_next_y < 0
  return 0 if pos_next_x > ROW || pos_next_y > COL
  return 0 if (@vertex[pos_next_x][pos_next_y] | FILTER[direction] == 15) && pos_next != GOAL
  return 0 if (ROW * (COL+1) + COL * (ROW+1)) - passed < n + 1
  return 0 if @vertex[pos_x][pos_y] & BLOCK_FROM[direction] != 0
  return 0 if @vertex[ROW][COL] == 15
  return 1 if pos_next == GOAL && n == 0

  @vertex[pos_x][pos_y] |=  BLOCK_FROM[direction]
  @vertex[pos_next_x][pos_next_y] |= BLOCK_TO[direction]

  cant_use = (check_vertex pos)
  cant_use.each do |k, v|
    @vertex[k[0]][k[1]] |= v
  end

  answer = move pos_next, direction, n, passed

  @vertex[pos_x][pos_y] &= (15 - BLOCK_FROM[direction])
  @vertex[pos_next_x][pos_next_y] &= (15 - BLOCK_TO[direction])
  cant_use.each do |k, v|
    @vertex[k[0]][k[1]] &= (15 - v)
  end

  if passed == 0
    g_from_x = (n.even? && direction == [1, 0]) || (n.odd? && direction == [0, 1]) ? [ROW, COL-1] : [ROW-1, COL]
    g_direction_x = (n.even? && direction == [1, 0]) || (n.odd? && direction == [0, 1]) ? [0, 1] : [1, 0]
    @vertex[g_from_x[0]][g_from_x[1]] &= (15 - BLOCK_FROM[g_direction_x])
    @vertex[ROW][COL] &= (15 - BLOCK_TO[g_direction_x])
  end
  answer
end

def move pos, direction, n, passed
  # p "call: #{pos}, #{direction}, #{n}, #{@vertex}" if pos == [3, 3] && direction == [1, 0]
  # sleep 1
  sum = 0
  if n >= 0
    sum += record_path_and_move pos, direction, n, passed + 1
    sum += record_path_and_move pos, [-1*direction[1], -1*direction[0]], n - 1, passed + 1
    sum += record_path_and_move pos, [direction[1], direction[0]], n - 1, passed + 1
  end
  sum
end

answer1, answer2 = 0, 0
answer1 = record_path_and_move [0,0], [0,1], n, 0
answer2 = record_path_and_move [0,0], [1,0], n, 0
puts answer1 + answer2
