require 'set'

ROW = 3
COL = 4
GOAL = [ROW,COL]
@vertex = [[2,3,3,3,2], [3,4,4,4,3], [3,4,4,4,3], [2,3,3,3,2]]

n = STDIN.gets.chomp.to_i
@path = Set.new
@calls = 0

def check_vertex pos
  cant_use = Set.new
  i = pos[0]
  j = pos[1]
  if @vertex[i][j] == 1
    if i-1 > 0
      if !@path.include? [[i, j], [i-1, j]]
        cant_use << [[i, j], [i-1, j]]
        cant_use << [[i-1, j], [i, j]]
      end
    end
    if j+1 < COL
      if !@path.include? [[i, j], [i, j+1]]
        cant_use << [[i, j], [i, j+1]]
        cant_use << [[i, j+1], [i, j]]
      end
    end
    if i+1 < ROW
      if !@path.include? [[i, j], [i+1, j]]
        cant_use << [[i, j], [i+1, j]]
        cant_use << [[i+1, j], [i, j]]
      end
    end
    if j-1 > 0
      if !@path.include? [[i, j], [i, j-1]]
        cant_use << [[i, j], [i, j-1]]
        cant_use << [[i, j-1], [i, j]]
      end
    end
  end
  cant_use
end

def record_path_and_move pos, direction, n, not_turned
  @calls += 1
  pos_next = [pos[0] + direction[0], pos[1] + direction[1]]
  path = [pos, pos_next]
  path_rev = [pos_next, pos]
  return 0 if @path.include? path

  return 0 if n < 0 && pos_next != GOAL
  return 0 if pos_next[0] < 0 || pos_next[1] < 0
  return 0 if pos_next[0] > ROW || pos_next[1] > COL
  return 0 if (ROW * (COL+1) + COL * (ROW+1)) - (@path.length / 2) - not_turned < n
  return 1 if pos_next == GOAL && n == 0

  @vertex[pos[0]][pos[1]] -= 1
  @vertex[pos_next[0]][pos_next[1]] -= 1

  @path << path
  @path << path_rev

  # check = pos[0] == 0 || pos[0] == ROW || pos[1] == 0 || pos[1] == COL
  check = true

  if check
    cant_use = (check_vertex pos)
    cant_use.map {|elm| elm[0]}.each do|vertex|
      @vertex [vertex[0]][vertex[1]] -= 1
    end
    # if cant_use.length > 0
    #   p "call: #{pos}, #{direction}, #{n}, #{@path.to_a}"
    #   p "    : #{cant_use.to_a}"
    # end
    cant_use.each {|p| @path << p}
  end

  answer = move pos_next, direction, n, not_turned

  @path.delete path
  @path.delete path_rev
  @vertex[pos[0]][pos[1]] += 1
  
  if check
    cant_use.each {|p| @path.delete p}
    @vertex[pos_next[0]][pos_next[1]] += 1
    cant_use.map {|elm| elm[0]}.each  do|vertex|
      @vertex [vertex[0]][vertex[1]] += 1
    end
  end

  answer
end

def move pos, direction, n, not_turned
  # p "call: #{pos}, #{direction}, #{n}, #{@path.to_a}"
  # sleep 1
  sum = 0
  if n >= 0
    sum += record_path_and_move pos, [-1, 0], (direction == [-1, 0] ? n : n - 1), (direction == [-1, 0] ? not_turned+1 : not_turned) if direction != [1, 0]
    sum += record_path_and_move pos, [0, 1], (direction == [0, 1] ? n : n - 1), (direction == [0, 1] ? not_turned+1 : not_turned) if direction != [0, -1]
    sum += record_path_and_move pos, [1, 0], (direction == [1, 0] ? n : n - 1), (direction == [1, 0] ? not_turned+1 : not_turned) if direction != [-1, 0]
    sum += record_path_and_move pos, [0, -1], (direction == [0, -1] ? n : n - 1), (direction == [0, -1] ? not_turned+1 : not_turned) if direction != [0, 1]
  end
  sum
end

# p "*"*40
answer = record_path_and_move [0,0], [0,1], n, 0
answer += record_path_and_move [0,0], [1,0], n, 0
puts answer
puts @calls