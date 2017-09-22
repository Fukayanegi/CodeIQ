
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Solver
  @@Pos = Struct.new(:x, :y)

  def initialize size, height
    @size = size
    @height = height
    @memo = (1..height).inject({}) do |acc, h|
      acc[h] = Hash.new(0)
      acc
    end

    @board = generate_board(size, height)
  end

  def generate_board size, height
    others = Hash.new(1)
    max = size < 100 ? size : 100
    r = 1
    max.times do |i|
      r0 = r = (r % 10009) * 99991;
      r1 = r = (r % 10009) * 99991;
      r2 = r = (r % 10009) * 99991;
      r3 = r = (r % 10009) * 99991;
      r4 = r = (r % 10009) * 99991;

      sqrX = r0 % size;
      sqrY = r1 % size;
      sqrW = r2 % (size - sqrX) % 100;
      sqrH = r3 % (size - sqrY) % 100;
      brdH = (r4 % height) + 1;

      (sqrX..sqrX+sqrW-1).each do |x|
        (sqrY..sqrY+sqrH-1).each do |y|
            others[x + y * size] = brdH;
        end
      end
    end
    others
  end

  def solve
    pos = 0
    while pos < @size**2
      height = @board[pos]

      # dlog({:call => "#{pos}, #{pos % @size}, #{pos / @size}, #{height}"}) if pos % 1000000 == 0
      # solve_inner pos, height

      left_length = @memo[height][pos - 1]
      up_length = @memo[height][pos - @size]
      left_up_length = @memo[height][pos - 1 - @size]
      dlog({:pos => pos, :left_length => left_length, :up_length => up_length, :left_up_length => left_up_length}) if pos == 52814

      min = left_length < up_length ? left_length : up_length
      min = min < left_up_length ? min : left_up_length

      @memo[height][pos] = 1 + min
  
      pos += 1
      # sleep 1
    end

    answer = @memo.values.map{|h| h.values.max}.select{|v| v}.max
    answer**2
  end
end

# inputs = []
# while line = STDIN.gets
#   inputs << line.chomp.split(",").map(&:to_i)
# end
# inputs = [[13, 5]]
# inputs = [[8, 5], [10, 4], [13, 5]]
# inputs = [[40,6], [100,5], [500,4], [1000,4], [1000,3], [2000,4], [2000,3], [3000,3]]
# inputs = [[40,6]]
inputs = [[500,4]]
# inputs = [[3000,3]]

inputs.each do |(size, height)|
  solver = Solver.new(size, height)
  puts solver.solve
end