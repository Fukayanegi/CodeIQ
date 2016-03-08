# リファクタリングの余地ありあり

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
    # p "count_target_pattern >> n: #{n}, no_strict: #{no_strict}"
    key = "#{n}:#{no_strict}"
    # return 0 if n <= 0
    # return 2 ** n if (n <= @x && no_strict == 1)
    return Solver.power n if (n <= @x && no_strict == 1)
    return 1 if @x == 0
    return 0 if n < @x
    return @memo[key] if @memo.include? key

    answer = 0
    if no_strict == 0
      # N-i..N-i-@x桁目が1でN-i+1桁目が0かつN-i-@x-1桁目が0となるものの累積
      0.upto(n - @x).each do |i|
        # 左側は1の連続が最大はNG => すでに数え上げているから
        left = Solver.new(@x - 1).count_target_pattern i - 1, 1
        right = count_target_pattern(n - i - @x - 1, 1)
        # p "loop >> #{n}, #{i}, #{left}, #{right}"
        answer += left * right
      end
    else
      0.upto(@x).each do |x|
        solver = Solver.new x
        answer += solver.count_target_pattern n, 0
      end
    end

    @memo[key] = answer
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

  def number_no_strict digits, order
    # p "number_no_strict >> digtis: #{digits}, order: #{order}"
    return 0 if digits == 1 && order == 1

    num = 0
    patterns = 0
    patterns_tmp = 0

    # 上位桁を1で埋める
    1.upto(@x).each do |upper_digits|
      break if patterns + patterns_tmp == order

      # 累積値の更新
      num += (1 << (digits - upper_digits))
      patterns += patterns_tmp

      # 初期化
      patterns_tmp = 1

      # p "loop >> #{upper_digits}, num: #{num.to_s(2)}, patterns: #{patterns}"

      # 0を挟んだ残りの桁で条件を満たすものをカウントする
      1.upto(digits - upper_digits - 1).each do |lower_digits|
        patterns_tmp = count_target_pattern lower_digits, 1
        # p "lower_digits: #{lower_digits}, patterns_tmp: #{patterns_tmp}, rest_order: #{order-patterns}"

        if patterns_tmp == order - patterns
          num += max_number lower_digits
          break
        elsif patterns_tmp > order - patterns
          patterns_before = lower_digits == 1 ? 0 : count_target_pattern(lower_digits - 1, 1)
          num += number_no_strict(lower_digits, order - patterns - patterns_before)
          patterns_tmp = order - patterns
          break
        end
      end
      # p "next #{num.to_s(2)}, patterns: #{patterns}, patterns_tmp: #{patterns_tmp}, order: #{order}"

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

      # 累積値の更新
      num += (1 << (digits - upper_digits))
      patterns += patterns_tmp

      # 初期化
      patterns_tmp = 0

      # p "loop >> #{upper_digits}, num: #{num.to_s(2)}, patterns: #{patterns}"

      # 0を挟んだ残りの桁で条件を満たすものをカウントする
      1.upto(digits - upper_digits - 1).each do |lower_digits|
        is_no_strict = upper_digits == @x ? 1 : 0
        patterns_tmp = count_target_pattern lower_digits, is_no_strict
        # p "lower_digits: #{lower_digits}, patterns_tmp: #{patterns_tmp}, rest_order: #{order-patterns}"

        if patterns_tmp == order - patterns
          num += max_number lower_digits
          break
        elsif patterns_tmp > order - patterns
          patterns_before = lower_digits == 1 ? 0 : count_target_pattern(lower_digits - 1, is_no_strict)
          # p "patterns_before: #{patterns_before}, lower_digits: #{lower_digits}"
          if is_no_strict == 1
            num += number_no_strict lower_digits, order - patterns - patterns_before
          else
            num += number lower_digits, order - patterns - patterns_before
          end
          patterns_tmp = order - patterns
          break
        end
      end
      # p "next #{num.to_s(2)}, patterns: #{patterns}, patterns_tmp: #{patterns_tmp}, order: #{order}"

    end

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
answer = solver.solve y
# p "#{answer.to_s(2)}"
p answer
