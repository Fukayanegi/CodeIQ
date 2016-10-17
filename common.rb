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
end