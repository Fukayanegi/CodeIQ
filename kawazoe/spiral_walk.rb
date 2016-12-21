def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

# n = STDIN.gets.chomp.to_i
n = 1000000
dlog({:n => n})

class Solver
  def self.function_g n
    answer = function_f(n)
    answer
  end

  def self.function_f m
    answer = 1
    w_ini = 1
    w, h = w_ini, 1
    walks = 2 * w + h
    while walks <= m
      # dlog({:w_ini => w_ini, :h => h})
      while walks <= m
        # dlog({:w => w, :h => h, :walks => walks})
        # answer[walks] = answer[walks] + ((w == h) ? 1 : 2)
        answer += ((w == h) ? 1 : 2)
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