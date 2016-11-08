# コマンドライン引数に"-dlog"があった場合にログを出力する関数
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
  attr_accessor :m, :n

  def initialize m, n
    @m = m
    @n = n
  end

  def create_cards_pattern sum, max_num, elements
    # dlog({:sum => sum, :elements => elements})
    return [] if sum < 0 || max_num * elements < sum
    return [[]] if elements == 0
    answer = []
    max_num.downto(1).each do |choice|
      tmp = create_cards_pattern sum - choice, choice, elements - 1
      tmp.each do |after_pattern|
        answer << after_pattern.dup.unshift(choice)
      end
    end
    answer
  end

  def solve
    # 奇数個の要素数で合計がmになる数値の組み合わせ
    patterns = (1..m).step(2).inject([]) do |acc, elements|
      acc.concat(create_cards_pattern(m, n, elements))
    end

    # 要素数m/2(後手),m/2+1(先手)に分けたときにm/2+1の方が大きくなる組み合わせ
    first_seconds = patterns.inject([]) do |acc, pattern|
      dlog({:pattern => pattern})
      turns = pattern.length / 2 + 1
      constitution = pattern.inject({}){|acc, v| acc[v] = (acc[v] || 0) + 1; acc}
      first_second = pattern.combination(turns).select{|scramble| scramble.inject(:+) > m / 2}.uniq.map do |scramble|
        tmp = scramble.inject({}){|acc, v| acc[v] = (acc[v] || 0) + 1; acc}
        rest = tmp.inject([]) do |acc, (key, value)|
          (constitution[key] - value).times{acc << key}
          acc
        end
        [scramble, rest]
      end
      acc.concat(first_second)
    end
    dlog({:first_seconds => first_seconds})
    
    # 先手、後手の組み合わせの取り方のパターン数を乗算
    first_seconds.inject(0) do |acc, (first, second)|
      dlog({:first => first, :second => second})
      first_constitution = first.inject({}){|acc, v| acc[v] = (acc[v] || 0) + 1; acc}
      dlog({:first_constitution => first_constitution})
      first_patterns = first.length.factorial / first_constitution.inject(1){|acc_f, (key, value)| acc_f * value.permutation}

      second_constitution = second.inject({}){|acc, v| acc[v] = (acc[v] || 0) + 1; acc}
      dlog({:second_constitution => second_constitution})
      second_patterns = second.length.factorial / second_constitution.inject(1){|acc_s, (key, value)| acc_s * value.permutation}
      acc += first_patterns * second_patterns
      acc
    end
  end
end

m, n = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:m => m, :n => n})

solver = Solver.new(m, n)
puts solver.solve