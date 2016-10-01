class Fixnum
  def factorial
    return 1 if self < 1
    (1..self).to_a.inject{|acc, v| acc * v}
  end

  def combination r = self
    self.permutation(r) / r.factorial
  end

  def permutation r = self
    self.factorial / (self - r).factorial
  end

  def repeated_combination r = self
    (self + r -1).combination r
  end
end

class Solver
  attr_accessor :m, :n

  def initialize m, n
    @m = m
    @n = n
  end

  def solve_inner winner, rest, winners_history
    if rest == 1
      winners_history << 1
      # p winners_history
      winners_history.pop
      # (W:L) = [G:C, C:P, P:G]
      return 3
    end

    answer = 0
    (0..(winner-2)).each do |loser|
      winners_history << (winner - loser)
      # loserが決定されるパターン数
      # 敗者が1人以上の場合、(W:L) = [G*(winnler-loser):C*loser, C*(winnler-loser):P*loser, P*(winnler-loser):G*loser]
      patterns = 3
      if loser == 0
        # 引き分けの場合
        # 全員が同じ手、または任意の3人でGCPを構成した後、残りの人数のGCPからなる組み合わせのパターン数
        patterns = 3 + 3.repeated_combination(winner - 3)
      end
      answer += patterns * (solve_inner winner - loser, rest - 1, winners_history)
      # p "loser: #{loser}, answer: #{answer}"
      winners_history.pop
    end
    answer
  end

  def solve
    solve_inner m, n, []
  end
end

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
solver = Solver.new m, n
puts solver.solve