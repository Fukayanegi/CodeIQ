DIRECTIONS = { up:[0,-1], right:[1,0], down:[0,1], left:[-1,0]}
DIRECTIONS_REV = {:up => :down, :right => :left, :down => :up, :left => :right}
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

@path = []
@max_turns = @m * @n

def solve x, y, direction, turns
  # p @path
  # p "#{x}, #{y}, #{direction}, #{turns}, #{@board[x][y]}, #{@board[x][y] == "#"}"
  # sleep 1
  if (@path.include? "#{x},#{y}") || (@board[x][y] == "#") || (turns >= @max_turns)
    # p "fin"
    return
  end
  if x == @m && y == @n
    @max_turns = turns
    return
  end

  # 深さ優先探索
  # 全てのパターンを探索する必要があるが、
  # 折り返し回数がこれまでの最大を超えた場合、行き止まりに行き着いた場合、すでに通ったマスにきた場合に
  # 早期に打ち切りできるため
  @path << "#{x},#{y}"
  next_drections = DIRECTIONS.select{|d, v| d != DIRECTIONS_REV[d]}
  next_drections.each do |next_direction, xy|
    turn = (direction != next_direction) ? 1 : 0
    r = solve x + xy[0], y + xy[1], next_direction, turns + turn
  end
  @path.pop
end

solve 1, 1, :right, 0
solve 1, 1, :down, 0
puts @max_turns