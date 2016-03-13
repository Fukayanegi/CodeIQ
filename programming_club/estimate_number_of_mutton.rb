m, n = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
p "#{m}, #{n}"

class Solver
  def initialize sheeps, c_teeth
    @sheeps = sheeps
    @c_teeth = c_teeth
  end

  def is_proper_input?
    return false if @c_teeth.odd?
    return false if @c_teeth > @sheeps * 6
    true
  end

  def solve
    [0,0]
  end
end

solver = Solver.new m, n

if !solver.is_proper_input?
  puts "error" 
else
  min, max = solver.solve
  puts "#{min} #{max}"
end