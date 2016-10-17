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

w, h, n = STDIN.gets.chomp.split(' ').map{|v| v.to_i}
p "w: #{w}, h: #{h}, n: #{n}"

# w * h の盤面を作る
board = Board.new(w, h)
board.show

# w * h の盤面に対して右手法でゴールまでたどるときの通過マス数をカウントする