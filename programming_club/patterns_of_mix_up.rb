class Solver
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve
    p @n
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new n
puts solver.solve