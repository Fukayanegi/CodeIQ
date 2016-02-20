class Solver
  def initialize m
    @m = m
  end

  def solve
    # m+1 > n * Math.log10(n) + 1 >= m となるnを求める
    answer = -1

    # 1からインクリメントして探索
    answer_tmp = 1

    while answer_tmp * 10 * Math.log10(answer_tmp * 10) < @m - 2 do
      answer_tmp = answer_tmp * 10
    end

    p "#{answer_tmp}"
    while (judge_value = answer_tmp * Math.log10(answer_tmp) + 1) < @m + 1 do
      if judge_value < @m + 1 && judge_value >= @m
        answer = answer_tmp
        break
      end
      answer_tmp += 1
    end

    return answer
  end
end

m = STDIN.gets.chomp!.to_i
solver = Solver.new m
p solver.solve