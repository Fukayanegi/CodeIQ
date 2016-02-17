venues, classes = STDIN.gets.chomp!.split(",").map{|v| v.to_i}
# p "#{venues}, #{classes}"

class Solver
  def initialize venues, classes
    @venues = venues
    @classes = classes
  end

  def solve
    answer = 0
    return answer if @venues == 0

    # 各会場で等しい回数受講するセッション数の最大値分繰り返す
    even_take_max = @classes / @venues
    taiking_patterns = Range.new(0, even_take_max)
    taiking_patterns.each do |take|
      # 受講数（各会場で等しい回数受講可能なセッション数*会場数）をセッション数の中から順列で取得する
      classes = Range.new(1, @classes)
      answer += classes.to_a.permutation(take * @venues).to_a.length
      # p "tmp_anser: #{answer} at #{take}"
    end
    # p answer
    return answer
  end
end

solver = Solver.new venues, classes
p solver.solve