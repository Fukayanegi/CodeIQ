class Solver
  attr_accessor :m, :n

  def initialize m, n
    @m = m
    @n = n
  end

  def solve
    answer = 0
    answer
  end
end

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
solver = Solver.new m, n
puts solver.solve