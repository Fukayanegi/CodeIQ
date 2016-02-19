class Solver
  def initialize m
    @m = m
  end

  def solve
    # m+1 > n * Math.log10(n) + 1 >= m となるnを求める
    answer = 1

    while (judge_value = answer * Math.log10(answer) + 1) < @m + 1 do
      if judge_value < @m + 1 && judge_value >= @m
        break
      end
      answer += 1
    end

    return answer
  end
end

m = STDIN.gets.chomp!.to_i
solver = Solver.new m
p solver.solve