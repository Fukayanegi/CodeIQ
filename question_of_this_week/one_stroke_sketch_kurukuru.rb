require 'set'

ROW = 3
COL = 4
GOAL = [ROW,COL]

n = STDIN.gets.chomp.to_i
@path = Set.new

def record_path_and_move pos, direction, n
  pos_next = [pos[0] + direction[0], pos[1] + direction[1]]
  path = [pos, pos_next]
  @path << path
  answer = move pos_next, direction, n
  @path.delete path

  answer
end

def move pos, direction, n
  # p "call: #{pos}, #{direction}, #{n}, #{@path.to_a}"
  # sleep 1
  return 0 if n < 0 && pos != GOAL
  return 0 if pos[0] < 0 || pos[1] < 0
  return 0 if pos[0] > ROW || pos[1] > COL
  return 1 if pos == GOAL && n == 0
  sum = 0
  if n >= 0
    # @path << [pos, [pos[0] - 1, pos[1]]]
    # sum += move [pos[0] - 1, pos[1]], [-1, 0], (direction == [-1, 0] ? n : n - 1)
    # @path.delete [pos, [pos[0] - 1, pos[1]]]
    sum += record_path_and_move pos, [0, 1], (direction == [0, 1] ? n : n - 1)
    sum += record_path_and_move pos, [1, 0], (direction == [1, 0] ? n : n - 1)
    # sum += move [pos[0], pos[1] - 1], [1, -1], (direction == [0, - 1] ? n : n - 1)
    # @path.delete pos
  end
  sum
end

answer = move [1,0], [1,0], n
answer += move [0,1], [0,1], n
puts answer