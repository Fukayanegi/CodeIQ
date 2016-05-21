require 'set'

ROW = 3
COL = 4
GOAL = [ROW,COL]
@vertex = [[2,3,3,3,2], [3,4,4,4,3], [3,4,4,4,3], [2,3,3,3,2]]

n = STDIN.gets.chomp.to_i
@path = Set.new

def check_vertex vertex, pos
  cant_use = Set.new
  vertex.each_with_index do |row, i|
    row.each_with_index do |val, j|
      if val == 1 && pos != [i, j]
        if i-1 > 0
          cant_use << [[i, j], [i-1, j]]
          cant_use << [[i-1, j], [i, j]]
        end
        if j+1 < COL
          cant_use << [[i, j], [i, j+1]]
          cant_use << [[i, j+1], [i, j]]
        end
        if i+1 < ROW
          cant_use << [[i, j], [i+1, j]]
          cant_use << [[i+1, j], [i, j]]
        end
        if j-1 > 0
          cant_use << [[i, j], [i, j-1]]
          cant_use << [[i, j-1], [i, j]]
        end
        # p "#{i}, #{j}, #{cant_use.to_a}"
      end
    end
  end
  cant_use
end

def record_path_and_move pos, direction, n
  pos_next = [pos[0] + direction[0], pos[1] + direction[1]]
  path = [pos, pos_next]
  path_rev = [pos_next, pos]
  return 0 if @path.include? path

  return 0 if n < 0 && pos_next != GOAL
  return 0 if pos_next[0] < 0 || pos_next[1] < 0
  return 0 if pos_next[0] > ROW || pos_next[1] > COL
  return 1 if pos_next == GOAL && n == 0

  @vertex[pos[0]][pos[1]] -= 1
  @vertex[pos_next[0]][pos_next[1]] -= 1

  @path << path
  @path << path_rev
  cant_use = (check_vertex @vertex, pos_next) - @path
  cant_use.map {|elm| elm[0]}.each  do|vertex|
    @vertex [vertex[0]][vertex[1]] -= 1
  end
  # if cant_use.length > 0
  #   p "call: #{pos}, #{direction}, #{n}, #{@path.to_a}"
  #   p "    : #{cant_use.to_a}"
  # end
  @path.merge cant_use

  answer = move pos_next, direction, n

  @path.delete path
  @path.delete path_rev
  @path = @path - cant_use

  @vertex[pos[0]][pos[1]] += 1
  @vertex[pos_next[0]][pos_next[1]] += 1
  cant_use.map {|elm| elm[0]}.each  do|vertex|
    @vertex [vertex[0]][vertex[1]] += 1
  end

  answer
end

def move pos, direction, n
  # p "call: #{pos}, #{direction}, #{n}, #{@path.to_a}"
  # sleep 1
  sum = 0
  if n >= 0
    sum += record_path_and_move pos, [-1, 0], (direction == [-1, 0] ? n : n - 1)
    sum += record_path_and_move pos, [0, 1], (direction == [0, 1] ? n : n - 1)
    sum += record_path_and_move pos, [1, 0], (direction == [1, 0] ? n : n - 1)
    sum += record_path_and_move pos, [0, -1], (direction == [0, -1] ? n : n - 1)
  end
  sum
end

# p "*"*40
answer = record_path_and_move [0,0], [0,1], n
answer += record_path_and_move [0,0], [1,0], n
puts answer