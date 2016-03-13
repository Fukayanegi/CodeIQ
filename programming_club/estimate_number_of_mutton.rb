m, n = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
p "#{m}, #{n}"

class Solver
  def initialize sheeps, c_teeth
    @sheeps = sheeps
    @c_teeth = c_teeth
  end

  def is_valid_input?
    return false if @c_teeth.odd?
    return false if @c_teeth > @sheeps * 6
    true
  end

  def max_muttons
    old_3 = @c_teeth / 6
    old_2 = (@c_teeth - 6 * old_3) / 4
    old_1 = (@c_teeth - 6 * old_3 - 4 * old_2) / 2

    @sheeps - [old_3, old_2, old_1].inject(:+)
  end

  def solve
    [max_muttons,0]
  end
end

solver = Solver.new m, n

if !solver.is_valid_input?
  puts "error" 
else
  min, max = solver.solve
  puts "#{min} #{max}"
end