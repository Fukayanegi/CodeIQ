class Solver
  @@dividend = 1000003
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve_inner n
    return 1 if n == 1
    answer = solve_inner(n - 1)
    answer + answer**2
  end

  def solve
    answer = solve_inner @n
    answer % @@dividend
  end
end

n = STDIN.gets.chomp.to_i

solver = Solver.new n
puts solver.solve
