DIRECTION = {:UP => 0, :RIGHT => 1, :DOWN => 2, :LEFT => 3}

class Board
  attr_accessor :board, :width, :height
  def initialize width, height
    @width = width
    @height = height
    @board = 2 ** (width + 2) - 1
    height.times do
      @board = @board << (width + 2) | ((1 << (width + 1)) + 1)
    end
    @board = @board << (width + 2) | 2 ** (width + 2) - 1
    @board_org = @board
  end

  def bit_length
    (width + 2) * (height + 2)
  end

  def mask row, col
    1 << (bit_length - 1 - (row * (width + 2) + col))
  end

  def show
    board.to_s(2).scan(/.{1,#{width + 2}}/).each do |line|
      puts line
    end
  end

  def fill cell
    cell -= 1
    row = cell / width + 1
    col = cell % width + 1
    self.board = (@board | mask(row, col))
  end

  def clear
    self.board = @board_org
  end

  def blank? row, col
    (board & mask(row, col)) == 0
  end

  def go_to_goal step_strategy
    answer = 1
    direction, row, col = DIRECTION[:DOWN], 1, 1
    while !(row == width && col == height)
      direction, row_next, col_next = step_strategy.step(direction, row, col, self)
      answer += 1 if row_next != row || col_next != col
      if direction == DIRECTION[:LEFT] && row_next == 1 && col_next == 1
        # スタート地点で左向きになっていた場合ゴールに辿り着けずに戻ってきたことになるので解なし
        answer = -1
        break
      end
      row, col = row_next, col_next
    end
    answer
  end
end

class RightHandStrategy
  def step direction, w, h, board
    # 方向転換もしくは右手側へ進む
    case direction
    when DIRECTION[:DOWN] then
      if board.blank?(h, w - 1)
        w -= 1
        direction = DIRECTION[:LEFT]
      else
        direction = DIRECTION[:RIGHT]
      end
    when DIRECTION[:RIGHT] then
      if board.blank?(h + 1, w)
        h += 1
        direction = DIRECTION[:DOWN]
      else
        direction = DIRECTION[:UP]
      end
    when DIRECTION[:UP] then
      if board.blank?(h, w + 1)
        w += 1
        direction = DIRECTION[:RIGHT]
      else
        direction = DIRECTION[:LEFT]
      end
    when DIRECTION[:LEFT] then
      if board.blank?(h - 1, w)
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

# w * h の盤面を作る
board = Board.new(w, h)

answer = w + h - 1
patterns = 0
# 総当たり
(2..w*h).to_a.combination(n).each do |fill_pattern|
  patterns += 1
  fill_pattern.each do |cell|
    board.fill(cell)
  end
  # board.show

  # 通過マス数をカウントする
  steps = board.go_to_goal RightHandStrategy.new
  answer = steps if answer < steps

  board.clear
end

puts answer
# puts patterns
