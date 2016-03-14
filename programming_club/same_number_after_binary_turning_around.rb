class Solver
  def initialize from, to
    @from = from
    @to = to
  end

  def solve
    under_digit = @from.to_s(2).length
    upper_digit = @to.to_s(2).length
    p "digits: #{under_digit}, #{upper_digit}"
  end
end

from, to = STDIN.gets.chomp.split(",").map{|val| val.to_i}
p "input: #{from}, #{to}"
p "input_by_binary: #{from.to_s(2)}, #{to.to_s(2)}"

solver = Solver.new from, to
solver.solve