class Solver
  class FileName
    attr_accessor :fullname, :str, :num, :ext
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
    @lines.sort_by! do |line|
      # p [line.str, line.num.to_i, line.num, line.ext]
      [line.str, line.num.to_i, line.num, line.ext]
    end

    @lines.each do |line|
      puts line.fullname
    end
  end
end

solver = Solver.new
solver.recieve_input
p "*"*40
solver.solve