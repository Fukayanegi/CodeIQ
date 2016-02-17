venues, classes = STDIN.gets.chomp!.split(",").map{|v| v.to_i}
p "#{venues}, #{classes}"

class Solver
  def initialize venues, classes
    @venues = venues
    @classes = classes
  end

  def solve
    # 各会場で等しい回数受講するセッション数の最大値分繰り返す
    even_take_max = @classes / @venues
    (0..even_take_max).each do |take|
      p take
    end
  end
end

solver = Solver.new venues, classes
solver.solve