class Solver
  def initialize n
    @count_of_num = n
    @min = 1 * n / 9
    @max = 4 * n / 9
    @memo = Hash.new
  end

  # count_of_num個の0,1,2,3の組み合わせでtarget_numとなる順列
  def count_patterns target_num, count_of_num
    return 1 if target_num == 0 && count_of_num == 0

    key = "#{target_num}:#{count_of_num}"
    return @memo[key] if @memo.include? key

    answer = 0
    (0..3).each do |num|
      if target_num - num >= 0 && target_num - num <= (count_of_num - 1) * 3
        answer += count_patterns target_num - num, count_of_num - 1
      end
    end
    @memo[key] = answer
    answer
  end

  def solve
    answer = 0
    (@min..@max).each do |magnification|
      answer += count_patterns 9 * magnification - @count_of_num, @count_of_num
    end
    answer
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new n
p solver.solve