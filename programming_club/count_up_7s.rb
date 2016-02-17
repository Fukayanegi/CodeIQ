class Solver
  @@target = "7"

  def initialize range_to
    @range_to = range_to
  end

  def solve
    answer = 0
    
    # range = Range.new(1, @range_to)
    # range.each do |num|
    #   answer += num.to_s.scan(@@target).count
    # end


    digit = @range_to.to_s.length - 1
    max_ditit_limit = @range_to / (10 ** digit)
    # p "#{digit}, #{max_ditit_limit}"

    digits = (1..digit).to_a
    (1..digit).each do |select_num|
      answer += digits.combination(select_num).to_a.count * select_num
    end
    # p "#{answer}"

    if max_ditit_limit >= 7
      answer = (max_ditit_limit + 1) * answer + 10 ** digit
    else
      answer = max_ditit_limit * answer
    end

    answer
  end
end

while (range_to = STDIN.gets) do
  solver = Solver.new range_to.chomp!.to_i
  p solver.solve
end