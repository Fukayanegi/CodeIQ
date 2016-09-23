class Solver
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve
    answer = 0
    answer
  end
end

n = STDIN.gets.chomp.to_i

solver = Solver.new n
puts solver.solve
