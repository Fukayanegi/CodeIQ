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
    @memo[n] = answer
    answer
  end

  # n桁以下の数の中で最大@x桁1が連続する数のp番目の数
  def solve_nmy n, y
    return 1
  end

  #　最大m桁1が連続する数がorder以下になる桁数とパターン数
  def solve_digits order
    patterns = 0
    digits = @x - 1

    while patterns < order
      # 繰り返し実行の最初に前回結果を累積する
      digits += 1

      patterns = count_target_pattern digits, 0

      p "#{digits}, #{patterns}"
    end

    return digits, patterns
  end

  def solve order
    digits, patterns = solve_digits order

    return order if order <= ("1"*@x).to_i(2)

    rest_patterns = order - patterns
    num = 1 << (digits + 1)

    while rest_patterns > 0
      1.upto(@x).each do |d|
        patterns = count_target_pattern(digits - d)
        if patterns > rest_patterns
          d - 1
          digits = digits - d
          break
        end
        rest_patterns -= patterns
      end
      num
    end

    num
  end
end

solver = Solver.new x
# p solver.solve y
p solver.solve_digits 29