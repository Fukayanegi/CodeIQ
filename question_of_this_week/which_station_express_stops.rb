def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

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

n_stations, n_expresses, n_super_epresses = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:n_stations => n_stations, :n_expresses => n_expresses, :n_super_epresses => n_super_epresses})

class Solver
  attr_accessor :n_stations, :n_expresses, :n_super_epresses
  def initialize n_stations, n_expresses, n_super_epresses
    @n_stations = n_stations
    @n_expresses = n_expresses
    @n_super_epresses = n_super_epresses
  end

  def solve
    answer = 0
    l_n_stations = n_stations - 2
    l_n_expresses = n_expresses - 2
    l_n_super_epresses = n_super_epresses - 2

    # 特急の停まる駅の組み合わせ
    c_se = l_n_stations.combination(l_n_super_epresses)
    dlog({:c_se => c_se})
    l_n_stations -= l_n_super_epresses
    l_n_expresses -= l_n_super_epresses

    # 急行だけが停まる駅の組み合わせ
    c_e = l_n_stations.combination(l_n_expresses)
    dlog({:c_e => c_e})

    answer = c_se * c_e

    answer
  end
end

solver = Solver.new(n_stations, n_expresses, n_super_epresses)
puts solver.solve