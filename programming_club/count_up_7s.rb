class Solver
  @@target = "7"

  def initialize range_to
    @range_to = range_to
  end

  def solve
    answer = 0
    
    range = Range.new(1, @range_to)
    range.each do |num|
      answer += num.to_s.scan(@@target).count
    end

    answer
  end
end

while (range_to = STDIN.gets) do
  solver = Solver.new range_to.chomp!.to_i
  p solver.solve
end