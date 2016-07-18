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

show_board @board

@path = []
@max_turns = @m * @n

def solve x, y, direction, turns
  # p @path
  # p "#{x}, #{y}, #{direction}, #{turns}, #{@board[y][x]}, #{@board[y][x] == "#"}"
  # sleep 1
  if (@path.include? "#{x},#{y}") || (@board[y][x] == "#") || (turns >= @max_turns)
    # p "#{x}, #{y}, #{direction}, #{turns}, #{@board[y][x]}, #{@board[y][x] == "#"}"
    # p "fin"
    return
  end
  if y == @m && x == @n
    p "#{@max_turns}"
    p @path
    @max_turns = turns
    return
  end

  # 深さ優先探索
  # 全てのパターンを探索する必要があるが、
  # 折り返し回数がこれまでの最大を超えた場合、行き止まりに行き着いた場合、すでに通ったマスにきた場合に
  # 早期に打ち切りできるため
  @path << "#{x},#{y}"
  # next_drections = DIRECTIONS.select{|d, v| d != DIRECTIONS_REV[direction] && d != direction}
  next_drections = DIRECTIONS.select{|d, v| d != DIRECTIONS_REV[direction]}
  
  # r = solve x + DIRECTIONS[direction][0], y + DIRECTIONS[direction][1], direction, turns if !direction.nil?
  next_drections.each do |next_direction, xy|
    turn = (direction != next_direction) ? 1 : 0
    r = solve x + xy[0], y + xy[1], next_direction, turns + turn
  end
  @path.pop
end

# @max_turns = 10
solve 1, 1, nil, -1
puts @max_turns