def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

a, b = STDIN.gets.chomp.split(" ").map(&:to_i)
# a, b = 7, 16
# a, b = 100, 150
# a, b = 123456789, 123459012
dlog({:a => a, :b => b})

class Solver
  attr_reader :start_point, :end_point, :sum, :converter
  def initialize start_point, end_point
    @start_point = start_point
    @end_point = end_point
    @converter = Hash.new do |h, key|
      value = 0
      tmp = key
      while tmp > 0
        tmp, quotient = tmp.divmod(10)
        value += quotient
      end
      h[key] = value
    end
    @sum = calculate(start_point, end_point)
    dlog({:converter => converter})
    dlog({:sum => sum})
  end

  def calculate start_point, end_point
    # dlog({:start_point => start_point, :end_point => end_point})
    start_point.upto(end_point).inject(0) do |acc, v|
      acc += converter[v]
      acc
    end
  end

  def solve
    sum_tmp = sum
    answer = 0
    start_point.upto(end_point - 1).inject(end_point) do |acc, v|
      sum_tmp -= converter[v]
      while sum_tmp < sum
        acc += 1
        sum_tmp += converter[acc]
      end
      if sum_tmp == sum
        dlog({:start_point => v + 1, :end_point => acc, :sum_tmp => sum_tmp})
        answer += 1
      end
      acc
    end
 
    sum_tmp = sum
    end_point.downto(start_point - 1).inject(start_point) do |acc, v|
      sum_tmp -= converter[v]
      while sum_tmp < sum
        acc -= 1
        break if acc <= 0
        sum_tmp += converter[acc]
      end
      if sum_tmp == sum
        dlog({:start_point => acc, :end_point => v - 1, :sum_tmp => sum_tmp})
        answer += 1
      end
      break if acc <= 0
      acc
    end
    answer
  end
end

solver = Solver.new(a, b)
puts solver.solve