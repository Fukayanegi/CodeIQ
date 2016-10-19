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

  def show
    board.to_s(2).scan(/.{1,#{width + 2}}/).each do |line|
      puts line
    end
  end

  def fill cell
    base = (width + 2) * (height + 2)
    cell -= 1
    row = cell / width + 1
    col = cell % width + 1
    self.board = (@board | (1 << (base - row * (width + 2) - col - 1)))
  end

  def clear
    self.board = @board_org
  end

  def blank? w, h
    base = (width + 2) * (height + 2)
    i = base - 1 - (h * (width + 2) + w)
    board & (1 << i) == 0
    # ("%0#{base}b" % self.board)[i].to_i
  end

  def go_to_goal step_strategy
    answer = 1
    direction, w, h = DIRECTION[:DOWN], 1, 1
    while !(w == width && h == height)
      # p "w: #{w}, h: #{h}, direction: #{direction}"
      direction, w_next, h_next = step_strategy.step(direction, w, h, self)
      answer += 1 if w_next != w || h_next != h
      if direction == DIRECTION[:LEFT] && w_next == 1 && h_next == 1
        answer = -1
        break
      end
      w, h = w_next, h_next
      # sleep(1)
    end
    answer
  end
end

class RightHandStrategy
  def step direction, w, h, board
    case direction
    when DIRECTION[:DOWN] then
      # p "w: #{w - 1}, h: #{h}, blank?: #{board.blank?(w - 1, h)}"
      if board.blank?(w - 1, h)
        w -= 1
        direction = DIRECTION[:LEFT]
      else
        direction = DIRECTION[:RIGHT]
      end
    when DIRECTION[:RIGHT] then
      # p "w: #{w}, h: #{h + 1}, blank?: #{board.blank?(w, h + 1)}"
      if board.blank?(w, h + 1)
        h += 1
        direction = DIRECTION[:DOWN]
      else
        direction = DIRECTION[:UP]
      end
    when DIRECTION[:UP] then
      # p "w: #{w + 1}, h: #{h}, blank?: #{board.blank?(w + 1, h)}"
      if board.blank?(w + 1, h)
        w += 1
        direction = DIRECTION[:RIGHT]
      else
        direction = DIRECTION[:LEFT]
      end
    when DIRECTION[:LEFT] then
      # p "w: #{w}, h: #{h - 1}, blank?: #{board.blank?(w, h - 1)}"
      if board.blank?(w, h - 1)
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
