def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

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

num_of_stations = STDIN.gets.chomp.to_i
# num_of_stations = 14
dlog({:num_of_stations => num_of_stations})

class Solver
  attr_reader :num_of_stations
  def initialize num_of_stations
    @num_of_stations = num_of_stations
  end

  def solve
    answer = 0
    # pattern1
    # L: - * - * *
    # R: * - * - -
    # [[1,3][0,2],[3,4][0,2]]
    # pattern2
    # L: - * - * -
    # R: * - * - *
    # [[1,3][0,2],[1,3][2,4]]

    2.upto(num_of_stations-2) do |left_opens|
      right_opens = num_of_stations - left_opens
      dlog({:left_opens => left_opens, :right_opens => right_opens})
      door_conbinations = num_of_stations.combination(left_opens)
      left_ride_patterns = left_opens - 1
      right_ride_patterns = right_opens - 1

      answer += left_ride_patterns * right_ride_patterns * door_conbinations
    end
    answer
  end
end

solver = Solver.new(num_of_stations)
puts solver.solve