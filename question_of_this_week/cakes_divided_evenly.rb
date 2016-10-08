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

class Solver
  attr_accessor :m, :n, :w

  def initialize m, n, w
    @m = m
    @n = n
    @w = w
  end

  def solve_inner num_of_people, rest, quota, limit
    return [] if rest > num_of_people * limit || rest < num_of_people * quota
    return [[]] if num_of_people == 0
    return [[rest]] if num_of_people == 1
    answer = []
    (quota..limit).each do |width|
      # p "num_of_people: #{num_of_people}, width: #{width}"
      tmp = solve_inner num_of_people - 1, rest - width, width, limit
      tmp.each{|cakes| cakes << width}
      answer.concat tmp
    end
    answer
  end

  def solve
    answer = 0
    w.downto(0).each do |max_w|
      (0..n-max_w).each do |i|
        min = i
        max = i + max_w

        # m-1人に最小の幅のケーキ、1に最大の幅のケーキを切り分けたときの余り
        rest = n - (min * (m - 1) + max)
        if rest >= 0 && rest <= (max-min)*(m-2)
          # p "min : #{min}, max: #{max}"
          # p "*suitable_rest: #{rest}, rest_person: #{m-2}"
          tmp = solve_inner m - 2, rest + min *(m - 2), min, max
          tmp.each{|cakes| cakes << min; cakes << max}
          tmp.each do |cakes|
            base = cakes.length.permutation
            counts = cakes.inject({}){|acc, v| (acc.include? v) || acc[v] = 0; acc[v] += 1; acc}
            counts.select{|k, v| v > 1}.each{|k, v| base /= v.factorial}
            answer += base
          end
        end
      end
    end
    answer
  end
end

m, n, w = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
solver = Solver.new m, n, w
puts solver.solve