def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

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
  def initialize m, n
    @choices = (2..m).to_a
    @m = m
    @n = n
  end

  def reverse_partial! ary, tail
    0.upto((tail - 1 ) / 2) do |idx|
      ary[idx], ary[tail-idx] = ary[tail-idx], ary[idx]
    end
    ary
  end

  def solve_inner selected, next_choices, rest
    if rest == 0
      # dlog({:selected => selected})
      answer = (@m - @n - 1).permutation
      return answer
    end

    @choices.inject(0) do |acc, choice|
      if (selected[choice-1] == nil && next_choices.include?(choice)) || selected[choice-1] == choice
        need_reset = selected[choice-1] == nil
        selected[choice-1] = choice
        reverse_partial!(selected, choice - 1)
        acc += solve_inner(selected, next_choices - [choice], rest - 1) if selected[0] != 1
        reverse_partial!(selected, choice - 1)
        selected[choice-1] = nil if need_reset
      end
      acc
    end
  end

  def solve
    init_ary = Array.new(@m)
    init_ary[0] = 1
    solve_inner(init_ary, @choices, @n)
  end
end

m, n = STDIN.gets.chomp.split(" ").map(&:to_i)
# m, n = 4, 3
# m, n = 6, 2
# m, n = 8, 15
# m, n = 9, 30
# m, n = 9, 0
dlog({:m => m, :n => n})

solver = Solver.new(m, n)
puts solver.solve