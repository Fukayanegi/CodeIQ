class Solver
  attr_accessor :n

  def initialize n
    @n = n
  end

  def solve
    answer = 0
    1.upto(@n).each do |longest_edge|
      1.upto(longest_edge).each do |middle_edge|
        answer += 2 * middle_edge - longest_edge if 2 * middle_edge - longest_edge > 0
      end
    end
    answer
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new n
puts solver.solve