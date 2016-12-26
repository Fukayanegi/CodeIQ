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

    yield self if block_given?
  end

  def bit_length
    (width + 2) * (height + 2)
  end

  def full
    ((1 << bit_length) - 1)
  end

  def mask row, col
    1 << (bit_length - 1 - (row * (width + 2) + col))
  end

  def unmask row, col
    # p "%0#{bit_length}b" % full
    # p "%0#{bit_length}b" % mask(row, col)
    # p "%0#{bit_length}b" % (full ^ (mask(row, col)))
    full ^ (mask(row, col))
  end

  def show
    board.to_s(2).scan(/.{1,#{width + 2}}/).each do |line|
      puts line
    end
  end

  def lock
    @board_org = board
  end

  def erase offsets, base_pos = [0,0]
    mask = offsets.inject(full){|acc, pos| acc & unmask(pos[0] + base_pos[0] + 1, pos[1] + base_pos[1] + 1)}
    # p "%0#{bit_length}b" % mask
    # mask.to_s(2).scan(/.{1,#{width + 2}}/).each do |line|
    #   puts line
    # end
    self.board = (board & mask)
  end

  def fill offsets, base_pos = [0,0]
    mask = offsets.inject(0){|acc, pos| acc | mask(pos[0] + base_pos[0] + 1, pos[1] + base_pos[1] + 1)}
    self.board = (board | mask)
  end

  def include? other
    (board & other.board) == other.board
  end

  def clear
    self.board = @board_org
  end

  def blank? row, col
    (board & mask(row, col)) == 0
  end
end

I = []
I << [[0, 0], [1, 0], [2, 0], [3, 0]]
I << [[0, 0], [0, 1], [0, 2], [0, 3]]

O = []
O << [[0, 0], [0, 1], [1, 0], [1, 1]]

L =[]
L << [[0, 0], [1, 0], [2, 0], [2, 1]]
L << [[1, 0], [1, 1], [1, 2], [0, 2]]
L << [[0, 0], [0, 1], [1, 1], [2, 1]]
L << [[0, 0], [0, 1], [0, 2], [1, 0]]
L << [[2, 0], [0, 1], [1, 1], [2, 1]]
L << [[0, 0], [0, 1], [0, 2], [1, 2]]
L << [[0, 0], [1, 0], [2, 0], [0, 1]]
L << [[0, 0], [1, 0], [1, 1], [1, 2]]

TETROMINOS = {:I => I, :O => O, :L => L}

# S = []
# board = Board.new(14, 14)
# # board.fill([[7, 7], [7, 8], [8, 7], [8, 8], ])
# S << board
# S.each{|board| board.show}

# input = STDIN.gets
input = "56 37 36 55 35 46 45 47"
cells = input.chomp.split(" ").map{|pos| [pos[1].to_i, pos[0].to_i]}
dlog({:cells => cells})
board = Board.new(10, 10) do |b|
  b.fill(cells)
  b.lock
  b.show
end

base_pos = cells.inject([9, 9]) do |acc, cell|
  acc[0] = cell[0] if acc[0] > cell[0]
  acc[1] = cell[1] if acc[1] > cell[1]
  acc
end
dlog({:base_pos => base_pos})

TETROMINOS.each do |tetromino, positions|
  positions.each do |position|
    other = Board.new(10, 10) do |b|
      b.fill(position, base_pos)
      b.show
    end
    if board.include?(other)
      # board.erase(position, base_pos)
      # board.show
      # board.clear
      # board.show
    end
  end
end
