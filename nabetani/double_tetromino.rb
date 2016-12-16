def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
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

  def fill positions
    mask = positions.inject(0){|acc, pos| acc | mask(pos[0], pos[1])}
    self.board = (@board | mask)
  end

  def clear
    self.board = @board_org
  end

  def blank? row, col
    (board & mask(row, col)) == 0
  end
end

I = []
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [7, 9], [7, 10], ])
I << board
board = Board.new(14, 14)
board.fill([[7, 7], [8, 7], [9, 7], [10, 7], ])
I << board
I.each{|board| board.show}

L = []
board = Board.new(14, 14)
board.fill([[7, 7], [8, 7], [9, 7], [9, 8], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [7, 9], [6, 9], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [8, 8], [9, 8], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [7, 9], [8, 7], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [6, 8], [5, 8], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [7, 9], [8, 9], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [8, 7], [9, 7], ])
L << board
board = Board.new(14, 14)
board.fill([[7, 7], [8, 7], [8, 8], [8, 9], ])
L << board
L.each{|board| board.show}

O = []
board = Board.new(14, 14)
board.fill([[7, 7], [7, 8], [8, 7], [8, 8], ])
O << board
O.each{|board| board.show}

S = []
board = Board.new(14, 14)
# board.fill([[7, 7], [7, 8], [8, 7], [8, 8], ])
S << board
S.each{|board| board.show}

# input = STDIN.gets
input = "56 37 36 55 35 46 45 47"
cells = input.chomp.split(" ").map{|pos| [pos[0].to_i, pos[1].to_i]}
dlog({:cells => cells})