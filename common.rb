class Fixnum
  def factorial
    return 1 if self < 1
    (1..self).to_a.inject{|acc, v| acc * v}
  end

  def combination r = self
    self.permutation(r) / r.factorial
  end

  def permutation r = self
    self.factorial / (self - r).factorial
  end

  def repeated_combination r = self
    (self + r -1).combination r
  end
end

class Array
  def histgram
    self.inject({}) do |acc, value|
      key = block_given? ? (yield value) : value
      acc[key] = (acc[key] || 0) + 1
      acc
    end
  end
end

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

@primes = []
@limit = 1
# 素数配列作成
def make_primes limit
  ((@limit+1)..limit).each do |num|
    is_prime = true
    quotient = limit
    @primes.each do |prime|
      # 判定対象が前回判定時の商を超える素数だった場合、
      # 以降の商は前回の素数を下回る（既に存在しないことが判定済）ため打ち切り
      if prime > quotient
        is_prime = true
        break
      end
      quotient = num / prime
      if num % prime == 0
        is_prime = false
        break
      end
    end
    @primes << num if is_prime
  end
  @limit = limit
end

# コマンドライン引数に"-dlog"があった場合にログを出力する関数
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end