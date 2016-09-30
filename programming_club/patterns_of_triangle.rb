class Solver
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve
    answer = 0
    # j = n / 2として、 Σ (n - 2k) [k=0..j]
    1.upto(@n).each do |longest_edge|
      j = longest_edge / 2
      answer += - j**2 + longest_edge*(1 + j)  - j
    end
    answer
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new n
puts solver.solve