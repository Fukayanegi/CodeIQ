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
    pattern = (1..m).step(2).inject([]) do |acc, elements|
      acc.concat(create_cards_pattern(m, n, elements))
    end

    # 要素数m/2(後手),m/2+1(先手)に分けたときにm/2+1の方が大きくなる組み合わせ
    
  end
end

m, n = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:m => m, :n => n})

solver = Solver.new(m, n)
p solver.solve


# 先手、後手の組み合わせの取り方のパターン数を乗算