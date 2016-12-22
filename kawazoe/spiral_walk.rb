def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

n = STDIN.gets.chomp.to_i
# n = 1000000
dlog({:n => n})

class Solver
  def self.function_g n
    answer = 0
    answer_f = function_f(n) do |m, patterns|
      # dlog({:m => m, :patterns => patterns})
      answer += patterns
    end
    dlog({:answer_f => answer_f})
    answer
  end

  def self.function_f m
    answer = 0
    w_ini = 1
    w, h = w_ini, 1
    walks = 2 * w + h
    while walks <= m
      # dlog({:w_ini => w_ini, :h => h})
      while walks <= m
        # dlog({:w => w, :h => h, :walks => walks})
        answer += ((w == h) ? 1 : 2) if walks == m
        yield walks, ((w == h) ? 1 : 2) if block_given?
        walks += 1 + h
        w, h = h, w + 1
      end

      w_ini += 2
      w = w_ini
      h = 1
      walks = 2 * w + h
    end
    answer
  end

  def self.solve n
    function_g(n)
  end
end

puts Solver.solve(n)