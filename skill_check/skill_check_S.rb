require 'set'

DIRECTIONS = {right:[1,0], down:[0,1], left:[-1,0], up:[0,-1]}
DIRECTIONS_REV = {:right => :left, :down => :up, :left => :right, :up => :down}
# TO DO: 広域な変数はあまり使いたくないのだが。。。

def show_board board
  board.each do |line|
    puts line
  end
end

@m, @n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
@board = []
@board << "#"*(@n+2)
@m.times do
  @board << "#" + STDIN.gets.chomp + "#"
end
@board << "#"*(@n+2)

# show_board @board

def progress x, y, direction
  # 行き止まりまで進む
  path = []
  while @board[y+direction[1]][x+direction[0]] != "#"
    y += direction[1]
    x += direction[0]
    path << [y, x]
  end

  path
end

turns = 0
path_from_all = Set.new
path_to_all = Set.new
path_from = Set.new
path_to = Set.new
path_from << [1, 1]
path_to << [@m, @n]
answer = 0

if path_from != path_to
  answer = while true do
    # p "turns = #{turns}"
    from = {}
    to = {}
    path_from_next = Set.new
    path_to_next = Set.new

    path_from.each do |(y, x)|
      DIRECTIONS.each do |direction, xy|
        from[direction] = progress x, y, xy
        path_from_next.merge from[direction]
      end
    end

    if (path_from_next.intersection path_to).length > 0
      break turns
    end

    path_to.each do |(y, x)|
      DIRECTIONS.each do |direction, xy|
        to[direction] = progress x, y, xy
        path_to_next.merge to[direction]
      end
    end
    # p path_to_next

    if (path_from_next.intersection path_to_next).length > 0
      break turns + 1 
    end
    turns += 2

    path_from = path_from_next.difference path_from_all
    path_to = path_to_next.difference path_to_all
    path_from_all.merge path_from_next
    path_to_all.merge path_to_next
  end
end

puts answer
