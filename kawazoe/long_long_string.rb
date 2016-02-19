class Solver
  def initialize m
    @m = m
  end

  def solve
    answer = 0
    return answer
  end
end

m = STDIN.gets.chomp!.to_i
solver = Solver.new m
p solver.solve