couples = STDIN.gets.chomp!

class Solver
  def initialize couples
    @couples = couples
  end

  def solve
    1
  end
end

solver = Solver.new couples
puts solver.solve