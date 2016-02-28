x, y = STDIN.gets.chomp!.split(",").map{|value| value.to_i}

class Solver
  def initialize x, y
    @x = x
    @y = y
  end

  def self.factorial(number)
    number = 0 if number.nil?
    (1..number).inject(1,:*)
  end

  def self.combination n, r
    self.factorial(n) / self.factorial(r)
  end

  def solve
    patterns = 0
    incremental = 0
    digits = @x - 1
    while patterns + incremental < @y do
      digits += 1
      patterns += incremental

      incremental = Solver.combination digits, @x
      p "#{digits}, #{@x}, #{incremental}"
    end

    ("0b" + "1"*digits)
  end
end

solver = Solver.new x, y
p solver.solve