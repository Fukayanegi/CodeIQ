test_case = [100, 213, 214, 1170, 87654321, 100000000]

class Solver
  @@dividend = 1000003
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve_inner n
    answer = 1
    (n - 1).times do
      answer = answer + answer**2
    end
    answer
  end

  def solve
    answer = solve_inner @n
    answer % @@dividend
  end
end

n = STDIN.gets.chomp.to_i

solver = Solver.new n
puts solver.solve
