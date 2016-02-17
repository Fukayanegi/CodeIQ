class Solver
  def initialize range_to
    @range_to = range_to
  end

  def solve
    0
  end
end

number = STDIN.gets.chomp!.to_i
range_to = STDIN.gets.chomp!.to_i
p "#{number}, #{range_to}"

solver = Solver.new range_to
p solver.solve