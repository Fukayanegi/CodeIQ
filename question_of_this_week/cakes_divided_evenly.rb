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

  # num_of_people人で幅restのケーキを最低quota幅、最大limit幅で分け合ったときの幅の組み合わせを配列にして返す
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
    # 最大-最小の差を固定して考える
    w.downto(0).each do |diff|
      # 最小の幅を固定
      (0..n-diff).each do |min|
        max = min + diff
        # m-1人に最小の幅のケーキ、1人に最大の幅のケーキを切り分けたときの余り
        rest = n - (min * m + diff)

        # 余りがあるかつ、最小1人以外を全員最大幅にしたときに配り切れる幅だけ残っていた場合解が存在する
        if rest >= 0 && rest <= diff * (m - 2)
          base = m.permutation
          # p "min : #{min}, max: #{max}"
          # p "*suitable_rest: #{rest}, rest_person: #{m-2}"
          rest_cakes = solve_inner m - 2, n - (min + max), min, max
          rest_cakes.each{|cakes| cakes << min; cakes << max}
          rest_cakes.each do |cakes|
            counts = cakes.inject({}){|acc, v| (acc.include? v) || acc[v] = 0; acc[v] += 1; acc}
            answer += counts.select{|k, v| v > 1}.inject(base){|acc, (k, v)| acc /= v.factorial; acc}
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