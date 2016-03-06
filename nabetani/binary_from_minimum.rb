x, y = STDIN.gets.chomp!.split(",").map{|value| value.to_i}

class Solver
  def initialize x
    @x = x
    @memo = Hash.new
  end

  def self.power num
    return 1 if num <= 0
    2 ** num
  end

  #　最大@x桁1が連続する2進数がorder以下になる桁数とパターン数
  def solve_digits order
    patterns = 0
    patterns_tmp = 0
    digits = @x - 1

    while patterns_tmp <= order
      # 繰り返し実行の最初に前回結果を累積する
      digits += 1
      patterns = patterns_tmp

      patterns_tmp = count_target_pattern digits, 0

      # p "#{digits}, #{patterns_tmp}"
    end

    return digits - 1, patterns
  end

  # n桁のbinaryの中に最大@x桁1が連続するものの数
  # no_strict == 1 の場合1の連続数は@x以下でもOK
  def count_target_pattern n, no_strict
    return Solver.power n if (n <= @x && no_strict == 1)
    return @memo[n] if @memo.include? n

    # N-i..N-i-@x桁目が1でN-i+1桁目が0かつN-i-@x-1桁目が0となるものの累積
    answer = 0
    0.upto(n - @x).each do |i|
      left = count_target_pattern i - 1, 1
      right = count_target_pattern(n - i - @x - 1, 1)
      answer += left * right
    end

    # 両端に1が@x個並ぶ2進数の場合、ダブルカウントが発生するため減算
    # FIXME: もっと綺麗なやり方があるはず
    if n > @x * 2
      answer -= count_target_pattern n - (@x + 1) * 2, 1
    end
    @memo[n] = answer
    answer
  end

  def max_number digits
    num = 1
    1.upto(digits - 1) do |try|
      num = (num << 1)
      num += 1 if (try + 1) % (@x + 1) != 0
    end
    num
  end

  # digits桁でorder番目の数
  # このメソッドが呼ばれる段階でdigits桁にorder番目の数が存在することは保証されている
  def number digits, order
    # p "number >> digtis: #{digits}, order: #{order}"
    num = 0
    patterns = 0
    patterns_tmp = 0

    # 上位桁を1で埋める
    1.upto(@x).each do |upper_digits|
      break if patterns + patterns_tmp == order

      num += (1 << (digits - upper_digits))
      patterns += patterns_tmp
      patterns_tmp = upper_digits != @x ? 0 : 1 # 初期化

      # p "loop >> #{upper_digits}, num: #{num.to_s(2)}, patterns: #{patterns}"

      # 0を挟んだ残りの桁で条件を満たすものをカウントする
      @x.upto(digits - upper_digits - 1).each do |lower_digits|
        patterns_tmp = count_target_pattern lower_digits, 0
        # p "lower_digits: #{lower_digits}, patterns_tmp: #{patterns_tmp}, rest_order: #{order-patterns}"
        if patterns_tmp == order - patterns
          num += max_number lower_digits
          break
        elsif patterns_tmp > order - patterns
          num += number lower_digits, order - patterns - count_target_pattern(lower_digits - 1, 0)
          patterns_tmp = order - patterns
          break
        end
      end
      # p "next #{num.to_s(2)}, patterns: #{patterns}, patterns_tmp: #{patterns_tmp}, order: #{order}"

    end

    # 上位@x桁が全て1の場合のパターン数を足しても足りない場合 = 0を挟んだ下位桁が@x桁ない場合
    if patterns + patterns_tmp != order
      # p "shortage >> num: #{num.to_s(2)}, shortage: #{order - patterns + patterns_tmp}"
      num += order - patterns - patterns_tmp
    end

    # p "#{num.to_s(2)}"
    num
  end

  def solve order
    return ("1"*@x).to_i(2) if order == 1

    # 1が最大@x個以下連続する2進数の桁数とそのときの最大値の順番を求める
    digits, patterns = solve_digits order
    rest_patterns = order - patterns

    # 最大値の順番と求められている順番が一致している場合最大値を返す
    return max_number digits if rest_patterns == 0

    # 桁数指定でrest_patterns番目の数を求める
    # p "#{digits}, #{patterns}, #{rest_patterns}"
    return number digits + 1, rest_patterns
  end
end

solver = Solver.new x
p solver.solve y