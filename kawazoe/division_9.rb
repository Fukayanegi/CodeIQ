# count_of_num個の0,1,2,3の組み合わせでtarget_numとなる順列
@patterns = []
def patterns target_num, count_of_num, pattern
  @patterns << pattern.dup if target_num == 0 && count_of_num == 0
  (0..3).each do |num|
    if target_num - num >= 0 && target_num - num <= (count_of_num - 1) * 3
      pattern << num
      patterns target_num - num, count_of_num - 1, pattern
      pattern.slice!(-1)
    end
  end
end

n = STDIN.gets.chomp.to_i
p "#{n}"

min, max = 1 * n / 9, 4 * n / 9

(min..max).each do |magnification|
  patterns 9 * magnification - n, n, []
end

p @patterns
p @patterns.length
