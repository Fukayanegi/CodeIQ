class Solver
  class FileName
    def initialize file_name
      @fullname = file_name
      @str = file_name.match(/^(\w+?)(?=(\d+\.))(\d+)\./)[1]
      @num = file_name.match(/(\d+)\./)[1]
      @ext = file_name.match(/\.(.*)$/)[1]
    end
  end

  attr_accessor :lines

  def initialize
    @lines = []
  end

  def recieve_input
    while line = STDIN.gets
      @lines << FileName.new(line.chomp)
    end
  end

  def solve

  end
end

solver = Solver.new
solver.recieve_input
solver.lines.each do |line|
  p line
end