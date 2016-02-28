class Solver
  attr_accessor :code_count
  attr_accessor :comment_count

  def initialize
    @code_count = 0
    @comment_count = 0
  end

  def solve
    while line = STDIN.gets do
      if /^#/.match line
        @comment_count += 1
      else
        @code_count += 1
      end
    end
  end
end

solver = Solver.new
solver.solve
puts "code:#{solver.code_count}"
puts "comment:#{solver.comment_count}"