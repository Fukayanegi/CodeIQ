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
  attr_accessor :a, :b
  def initialize a, b
    @a = a
    @b = b
  end

  def increase_n_ary_number_fixed_digit n, first_border, digit
    return [[]] if digit == 0
    return [] if first_border > n - 1
    return (first_border..n-1).map{|v| [v]} if digit == 1
    num = []
    first_border.upto(n-digit).each do |first|
      tmp = increase_n_ary_number_fixed_digit(n, first + 1, digit - 1)
      dlog({:tmp => tmp})
      tmp.each do |under_digits|
        num << under_digits.unshift(first)
      end
    end
    num
  end

  def decrease_n_ary_number_fixed_digit n, first_border, digit
    # dlog({:n => n, :first_border => first_border, :digit => digit})
    return [[]] if digit == 0
    return [] if first_border < 0
    return (0..first_border).map{|v| [v]} if digit == 1
    num = []
    first_border.downto(digit-1).each do |first|
      tmp = decrease_n_ary_number_fixed_digit(n, first - 1, digit - 1)
      dlog({:tmp => tmp})
      tmp.each do |under_digits|
        num << under_digits.unshift(first)
      end
    end
    num
  end

  def n_ary_number n, first_border, max_digit
    num = []
    1.upto(max_digit).each do |digit|
      num.concat(yield n, first_border, digit)
    end
    num.map{|ary| ary.join.to_i(n)}
  end

  def increase_n_ary_number n, first_border, max_digit
    n_ary_number(n, first_border, max_digit) do |n, first_border, max_digit|
      increase_n_ary_number_fixed_digit(n, first_border, max_digit)
    end
  end

  def decrease_n_ary_number n, first_border, max_digit
    n_ary_number(n, first_border, max_digit) do |n, first_border, max_digit|
      decrease_n_ary_number_fixed_digit(n, first_border, max_digit)
    end
  end

  def solve
    increase_num = increase_n_ary_number a, 1, a - 1
    decrease_num = decrease_n_ary_number b, b - 1, b
    dlog({:increase_num => increase_num})
    dlog({:decrease_num => decrease_num})
    (increase_num & decrease_num).max
  end
end

a, b = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:a => a, :b => b})

solver = Solver.new(a, b)
puts solver.solve