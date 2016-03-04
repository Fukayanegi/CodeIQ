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

  # n桁のbinaryの中に最大@x桁1が連続するものの数
  def count_target_pattern n, recursive
    return Solver.power n if (n <= @x && recursive == 1)
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

  #　最大m桁1が連続する数がorder以下になる桁数とパターン数
  def solve_digits order
    patterns = 0
    patterns_tmp = 0
    digits = @x - 1

    while patterns_tmp <= order
      # 繰り返し実行の最初に前回結果を累積する
      digits += 1
      patterns = patterns_tmp

      patterns_tmp = count_target_pattern digits, 0

      p "#{digits}, #{patterns_tmp}"
    end

    return digits - 1, patterns
  end

  def max_number digits
    num = 1
    (digits - 1).times do |try|
      num = (num << 1)
      num += 1 if (try + 1) % @x != 0
    end
    num
  end

  def solve order
    return ("1"*@x).to_i(2) if order == 1

    digits, patterns = solve_digits order
    rest_patterns = order - patterns
    return max_number digits if rest_patterns == 0
    
    num = 1 << digits

    p "#{digits}, #{patterns}, #{rest_patterns}, #{num}, #{num.to_s(2)}"

    (@x + 1).downto(2).each do |d|
      patterns = count_target_pattern digits - d, 0
      if patterns <= rest_patterns
        num += solve rest_patterns
        break
      end
    end

    num
  end
end

solver = Solver.new x
p solver.solve y