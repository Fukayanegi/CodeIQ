N = STDIN.gets.chomp.to_i

class Solver
  def initialize n
    @n = n
  end

  def next_number
    return Random.rand(@n) + 1
  end

  def solve tries
    (1..@n).each do |limit|
      tries.times do
        p "#{limit}: #{next_number}"
      end
    end
  end
end

solver = Solver.new N
solver.solve 3