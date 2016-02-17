class Solver
  def initialize range_to
    @range_to = range_to
  end

  def solve
    answer = 0
    
    range = Range.new(1, @range_to)
    range.each do |num|
      answer += num.to_s.scan("7").count
    end

    answer
  end
end

number = STDIN.gets.chomp!.to_i
range_to = STDIN.gets.chomp!.to_i
# p "#{number}, #{range_to}"

solver = Solver.new range_to
p solver.solve