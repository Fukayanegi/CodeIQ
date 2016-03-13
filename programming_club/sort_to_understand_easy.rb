class Solver
  attr_accessor :lines

  def initialize
    @lines = []
  end

  def recieve_input
    while line = STDIN.gets
      @lines << line.chomp
    end
  end
end

solver = Solver.new
solver.recieve_input
p solver.lines