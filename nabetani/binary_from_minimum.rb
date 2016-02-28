x, y = STDIN.gets.chomp!.split(",").map{|value| value.to_i}

class Solver
  def initialize x, y
    @x = x
    @y = y
  end

  def solve
  end
end

solver = Solver.new x, y
solver.solve