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
  def initialize digit
    @digit = digit
  end

  def solve
    dlog({:pi => Math::PI})
    target_n, target_d = ("%s" % Math::PI)[2..(2 + @digit - 1)].to_i, 10**@digit

    denominator = 1
    while true
      quotient, surplus = (target_n * denominator).divmod(target_d )

      # break if quotient + 1 < denominator && (target_d - surplus) / denominator == 0
      break if (target_d - surplus) / denominator == 0
      denominator += 1
    end
    denominator
  end
end

n = STDIN.gets.chomp.to_i
# n = 2
# n = 3
# n = 11
dlog({:n => n})

solver = Solver.new(n)
puts solver.solve