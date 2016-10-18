DIRECTION = {:UP => 0, :RIGHT => 1, :DOWN => 2, :LEFT => 3}

class Board
  attr_accessor :board, :width, :height
  def initialize width, height
    @width = width
    @height = height
    @board = []
    @board << "#" * (width + 2)
    height.times do
      @board << "#" + "." * width + "#"
    end
    @board << "#" * (width + 2)
  end

  def show
    board.each do |line|
      puts line
    end
  end

  def fill cell
    cell = cell - 1
    row = cell / width + 1
    col = cell - (row - 1) * width + 1
    # p "row: #{row}, col: #{col}"
    board[row][col] = "#"
  end

  def clear
    1.upto(height) do |row|
      1.upto(width) do |col|
        board[row][col] = "."
      end
    end
  end

  def solve step_strategy
    answer = 1
    direction, w, h = DIRECTION[:DOWN], 1, 1
    while !(w == width && h == height)
      # p "w: #{w}, h: #{h}"
      # sleep(1)
      direction, w_next, h_next = step_strategy.step(direction, w, h, board)
      answer += 1 if w_next != w || h_next != h
      if direction == DIRECTION[:LEFT] && w_next == 1 && h_next == 1
        answer = -1
        break
      end
      w, h = w_next, h_next
    end
    answer
  end
end

class RightHandStrategy
  def step direction, w, h, board
    case direction
    when DIRECTION[:DOWN] then
      if board[h][w-1] == "."
        w -= 1
        direction = DIRECTION[:LEFT]
      else
        direction = DIRECTION[:RIGHT]
      end
    when DIRECTION[:RIGHT] then
      if board[h+1][w] == "."
        h += 1
        direction = DIRECTION[:DOWN]
      else
        direction = DIRECTION[:UP]
      end
    when DIRECTION[:UP] then
      if board[h][w+1] == "."
        w += 1
        direction = DIRECTION[:RIGHT]
      else
        direction = DIRECTION[:LEFT]
      end
    when DIRECTION[:LEFT] then
      if board[h-1][w] == "."
        h -= 1
        direction = DIRECTION[:UP]
      else
        direction = DIRECTION[:DOWN]
      end
    end
    [direction, w, h]
  end
end

w, h, n = STDIN.gets.chomp.split(' ').map{|v| v.to_i}
# p "w: #{w}, h: #{h}, n: #{n}"

# w * h の盤面を作る
board = Board.new(w, h)
# board.board[4][2] = "#"
# board.board[4][3] = "#"
# board.board[3][3] = "#"
# board.board[2][2] = "#"
# board.board[2][3] = "#"

answer = w + h
# 総当たり
(2..w*h).to_a.combination(n).each do |fill_pattern|
  fill_pattern.each do |cell|
    board.fill(cell)
  end
  # board.show

  # 通過マス数をカウントする
  steps = board.solve RightHandStrategy.new
  answer = steps if answer < steps

  board.clear
end

puts answer

# nマス塗りつぶした、右手法で辿ったときに通過マス数が最長となる盤面を作る
# set = (w - 1) / 3
# 1.upto(n) do |i_fill|
#   if i_fill < h * set
#     row = (h - (i_fill - 1) % (h - 1))
#     col = (2 + (i_fill - 1) / (h - 1)) + (i_fill.even? ? 1 : 0)
#   end
#   p "row: #{row}, col: #{col}"
#   board.board[row][col] = "#"
# end

# board.show