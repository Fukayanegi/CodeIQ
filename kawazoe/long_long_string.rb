  class Solver
    def initialize m
      @m = m
    end

    def solve
      # m+1 > n * Math.log10(n) + 1 >= m となるnを求める

      # 答えの初期値を-1にしておき、答えが見つかったら上書きする
      answer = -1

      answer_tmp = 0    # 探索用変数
      answer_step = 0   # 探索時増分保持用変数
      m_tmp = 0         # 探索用変数を更新した場合のmの値

      # answer_tmpをanswer_tmp+answer_stepに更新しても問題ない限り10倍づつanswer_stepを更新しながらループ
      # FIXME: n * Math.log10(n) = m の数学的な解き方がわからないため、効率的な探索でカバー
      while @m - m_tmp > 0 && answer_step != 1 do
        answer_tmp += answer_step

        answer_step = 1
        while (answer_tmp + answer_step * 10) * Math.log10(answer_tmp + answer_step * 10) < @m - 2 do
          answer_step = answer_step * 10
        end
        m_tmp = ((answer_tmp + answer_step) * Math.log10(answer_tmp + answer_step) + 1).ceil
        # p "#{@m}, #{m_tmp}, #{answer_tmp}, #{answer_step}"
      end

      # 最後はインクリメントして探索
      # p "#{answer_tmp}"
      while (judge_value = answer_tmp * Math.log10(answer_tmp) + 1) < @m + 1 do
        if judge_value < @m + 1 && judge_value >= @m
          answer = answer_tmp
          break
        end
        answer_tmp += 1
        # p answer_tmp if answer_tmp % 100000 == 0
      end

      return answer
    end
  end

  m = STDIN.gets.chomp!.to_i
  solver = Solver.new m
  p solver.solve