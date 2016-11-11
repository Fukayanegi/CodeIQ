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

class Array
  def histgram
    self.inject({}) do |acc, value|
      key = block_given? ? (yield value) : value
      acc[key] = (acc[key] || 0) + 1
      acc
    end
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

  def calc_duplication constitution, choices, rest
    # dlog({:constitution => constitution, :choices => choices, :rest => rest})
    if rest == 0
      dlog({:constitution => constitution})
      dlog({:choices => choices})
      all_count = constitution.inject(0){|acc, (key, value)| acc += value}
      dlog({:all_count => all_count})
      first_count = choices.inject(0){|acc, (key, value)| acc += value}
      first = first_count.permutation / choices.inject(1){|acc, (key, value)| acc * value.permutation}
        
      dlog({:first => first})
      first_sum = choices.inject(0){|acc, (key, value)| acc + key * value}
      second = (all_count - first_count).permutation / \
        constitution.inject(1){|acc, (key, value)| acc * (value - (choices[key] || 0)).permutation}
      dlog({:second => second})
      second_sum = constitution.inject(0){|acc, (key, value)| acc + key * value} - first_sum
      return first_sum > second_sum ? [first * second] : [0]
    end

    min_value = choices.keys.max || 0
    return [0] if (constitution.select{|key, value| key > min_value}.values.inject(:+) || 0) < rest

    dlog({:min_value => min_value})
    answer = []
    element, max_choice = constitution.sort_by{|key, value| key}.find{|key, value| key > min_value}
    0.upto(max_choice < rest ? max_choice : rest).map do |choice|
      choices[element] = choice
      answer.concat(calc_duplication(constitution, choices, rest - choice))
      choices.delete(element)
    end
    answer
  end

  def solve
    # 奇数個の要素数で合計がmになる数値の組み合わせ
    patterns = (1..m).step(2).inject([]) do |acc, elements|
      acc.concat(create_cards_pattern(m, n, elements))
    end

    answer = patterns.inject(0) do |acc, pattern|
      turns = pattern.length / 2 + 1
      constitution = pattern.histgram
      acc += calc_duplication(constitution, {}, turns).inject(:+)
    end
  end
end

m, n = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:m => m, :n => n})

solver = Solver.new(m, n)
puts solver.solve