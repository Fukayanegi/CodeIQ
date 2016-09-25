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
end

class Solver
  attr_accessor :n

  def initialize n
    @n = n
    @memo = {}
    @mask = ("1" * @n).to_i(2)
  end

  def solve_inner2 n
    return @memo[n] if @memo.include? n
    return 1 if n == 2

    # 全てのパターン数から1人以上が正しいカバンを持ち帰るパターン数を減算する
    all_count = n.factorial
    # 全員が正しいカバンを持ち帰るケースが必ずある
    ex_count = 1
    1.upto(n-2).each do |correct|
      # correct人が正しいカバンを持ち帰り、n-correct人が全て異なるカバンを持ち帰るパターン数
      ex_count += n.combination(correct) * solve_inner2(n - correct)
    end
    @memo[n] = all_count - ex_count
    @memo[n]
  end

  def solve
    solve_inner2 @n
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new n
puts solver.solve