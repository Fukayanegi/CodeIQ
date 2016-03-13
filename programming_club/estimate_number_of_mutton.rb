m, n = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
p "#{m}, #{n}"

class Solver
  def initialize sheeps, c_teeth
    @sheeps = sheeps
    @c_teeth = c_teeth
  end

  def solve
    [0,0]
  end
end

solver = Solver.new m, n
min, max = solver.solve
puts "#{min} #{max}"