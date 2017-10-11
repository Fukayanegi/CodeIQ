
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
  def initialize size, height
    @size = size
    @height = height
    @memo = (1..height).inject({}) do |acc, h|
      acc[h] = Hash.new(0)
      acc
    end

    @board = generate_board(size, height)
    # show_board
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

  def show_board
    @size.times do |y|
      line = ""
      @size.times do |x|
        line << @board[x + y * @size].to_s
      end
      puts line
    end
  end

  def solve
    pos = 0
    memo_lu = Array.new(@size * 2 - 1) {0}
    memo_l = Array.new(@size * 2 - 1) {0}
    answer = 1

    while pos < @size * 2 - 1
      # dlog({:pos => pos, :time => Time.now - START}) if pos % 100 == 0
      adjust = (pos >= @size ? (pos - @size + 1) : 0)
      loops = pos < @size ? pos + 1 : @size*2 - pos - 1
      answer_tmp_prev = 0

      loops.times do |i|
        x = i + adjust
        y = pos - i - adjust
        height = @board[y * @size + x]
        # dlog({:i => i, :x => x, :y => y, :height => height})

        answer_tmp = 1
        left = memo_l[i]
        up = memo_l[i + 1]
        if @board[y * @size + x - 1] == height && @board[(y - 1) * @size + x] == height && @board[(y - 1) * @size + x - 1] == height
          # dlog({:memo_lu => memo_lu[i], :memo_l => memo_l, :left => left, :up => up})
          answer_tmp = answer_tmp + [memo_lu[i], left, up].min
        end

        memo_lu[i] = pos <= @size - 2 ? left : up
        memo_l[i] = pos <= @size - 2 ? answer_tmp_prev : answer_tmp
        answer = answer_tmp if answer_tmp > answer

        answer_tmp_prev = answer_tmp if pos <= @size - 2 
      end

      memo_l[loops] = answer_tmp_prev if pos <= @size - 2

      # dlog({:memo_lu => memo_lu})
      # dlog({:memo_l => memo_l})

      pos = pos + 1
    end
    answer**2
  end

# inputs = []
# while line = STDIN.gets
#   inputs << line.chomp.split(",").map(&:to_i)
# end
# inputs = [[8, 5]]
# inputs = [[8, 5], [10, 4], [13, 5]]
# answers = [16, 16, 25]
inputs = [[40,6], [100,5], [500,4], [1000,4], [1000,3], [2000,4], [2000,3], [3000,3]]
# answers = [289, 2704, 8464, 48400, 48400, 281961, 254016, 456976]
# inputs = [[40,6]]
# inputs = [[100,5]]
# inputs = [[500,4]]
# inputs = [[3000,3]]

START = Time.now
inputs.each do |(size, height)|
  solver = Solver.new(size, height)
  puts solver.solve
end
puts "#{Time.now - START}"