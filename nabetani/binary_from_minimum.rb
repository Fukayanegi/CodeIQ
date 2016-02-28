x, y = STDIN.gets.chomp!.split(",").map{|value| value.to_i}

class Solver
  def initialize x, y
    @x = x
    @y = y
  end

  def self.power num
    return 1 if num <= 0
    2 ** num
  end

  # def self.factorial(number)
  #   return 1 if number <= 1
  #   number = 0 if number.nil?
  #   (1..number).inject(1,:*)
  # end

  # def self.combination n, r
  #   self.factorial(n) / self.factorial(r)
  # end

  def solve
    patterns = 0
    incremental = 0
    digits = @x - 1

    while patterns + incremental < @y do
      digits += 1
      patterns += incremental

      # N桁の2進数を考えたとき、
      # N-i..N-i-@x桁目が1でN-i+1桁目が1とならないかつN-i-@x-1桁目が1とならないケースが
      # 最大1が@x桁続く数字
      incremental = 0
      (0..digits-@x).each do |i|
        left = Solver.power i - 1
        right = Solver.power(digits - i - @x - 1)
        incremental += left * right
      end
      # 前回の桁数からの増分を記録する
      incremental -= patterns

      p "#{digits}, #{@x}, #{incremental}, #{patterns}"
    end

    # digits桁の中に@y番目の数がある
    ("0b" + "1"*digits)
  end
end

solver = Solver.new x, y
p solver.solve