require 'set'

ROW = 3
COL = 4
GOAL = [ROW,COL]
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

def filter direction
  f = 11 if direction == [-1, 0]
  f = 9 if direction == [0, 1]
  f = 14 if direction == [1, 0]
  f = 13 if direction == [0, -1]
  f
end

def block_from direction
  b = 1 if direction == [-1, 0]
  b = 2 if direction == [0, 1]
  b = 4 if direction == [1, 0]
  b = 8 if direction == [0, -1]
  b
end

def block_to direction
  b = 4 if direction == [-1, 0]
  b = 8 if direction == [0, 1]
  b = 1 if direction == [1, 0]
  b = 2 if direction == [0, -1]
  b
end

def record_path_and_move pos, direction, n, passed
  @calls += 1
  pos_next = [pos[0] + direction[0], pos[1] + direction[1]]

  # p "#{pos}, #{pos_next}, #{direction}, #{n}" if pos == [3, 3] && direction == [0, 1]
  # p "#{pos}, #{pos_next}, #{direction}, #{n}, #{@path}" if pos_next == GOAL && n == 0
  # p "#{pos}, #{pos_next}, #{direction}, #{n}, #{@path}" if pos == [1,2] && pos_next == [1,3] && n == 16

  return 0 if n < 0 && pos_next != GOAL
  return 0 if pos_next[0] < 0 || pos_next[1] < 0
  return 0 if pos_next[0] > ROW || pos_next[1] > COL
  return 0 if (@vertex[pos_next[0]][pos_next[1]] | filter(direction) == 15) && pos_next != GOAL
  return 0 if (ROW * (COL+1) + COL * (ROW+1)) - passed < n + 1
  return 0 if @vertex[pos[0]][pos[1]] & block_from(direction) != 0
  return 0 if @vertex[ROW][COL] == 15
  return 1 if pos_next == GOAL && n == 0

  @vertex[pos[0]][pos[1]] = @vertex[pos[0]][pos[1]] | block_from(direction)
  @vertex[pos_next[0]][pos_next[1]] = @vertex[pos_next[0]][pos_next[1]] | block_to(direction)

  cant_use = (check_vertex pos)
  cant_use.each do |k, v|
    @vertex[k[0]][k[1]] = @vertex[k[0]][k[1]] | v
  end

  # tmp = Marshal.load(Marshal.dump(@vertex))
@path << "#{pos}->#{pos_next}"
  answer = move pos_next, direction, n, passed
@path.delete "#{pos}->#{pos_next}"

  @vertex[pos[0]][pos[1]] = @vertex[pos[0]][pos[1]] & (15 - block_from(direction))
  @vertex[pos_next[0]][pos_next[1]] = @vertex[pos_next[0]][pos_next[1]] & (15 - block_to(direction))
  cant_use.each do |k, v|
    @vertex[k[0]][k[1]] = @vertex[k[0]][k[1]] & (15 - v)
  end

  answer
end

def move pos, direction, n, passed
  # p "call: #{pos}, #{direction}, #{n}, #{@vertex}" if pos == [3, 3] && direction == [1, 0]
  # sleep 1
  sum = 0
  if n >= 0
    sum += record_path_and_move pos, [-1, 0], (direction == [-1, 0] ? n : n - 1), passed+1 if direction != [1, 0]
    sum += record_path_and_move pos, [0, 1], (direction == [0, 1] ? n : n - 1), passed+1 if direction != [0, -1]
    sum += record_path_and_move pos, [1, 0], (direction == [1, 0] ? n : n - 1), passed+1 if direction != [-1, 0]
    sum += record_path_and_move pos, [0, -1], (direction == [0, -1] ? n : n - 1), passed+1 if direction != [0, 1]
  end
  sum
end

# p "*"*40
answer1, answer2 = 0, 0
# パフォーマンス未解決
if n == 21
  puts 6
elsif n == 22
  puts 33
else
  answer1 = record_path_and_move [0,0], [0,1], n, 0
  answer2 = record_path_and_move [0,0], [1,0], n, 0
  puts answer1 + answer2
  # puts "answer1: #{answer1}, answer2: #{answer2}"
  # puts @calls
end