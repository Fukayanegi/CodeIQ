  class Solver
    def initialize m
      @m = m
    end

    def solve
      # m+1 > n * Math.log10(n) + 1 >= m となるnを求める
      answer = -1

      # 0からインクリメントして探索
      answer_tmp = 0

      answer_step = 0
      m_tmp = 0

      while @m - m_tmp > 0 do
        answer_tmp += answer_step

        answer_step = 1
        while answer_step * 10 * Math.log10(answer_step * 10) < @m - 2 do
          answer_step = answer_step * 10
        end
        m_tmp = ((answer_tmp + answer_step) * Math.log10(answer_tmp + answer_step) + 1).ceil
        p "#{@m}, #{m_tmp}, #{answer_tmp}, #{answer_step}"
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