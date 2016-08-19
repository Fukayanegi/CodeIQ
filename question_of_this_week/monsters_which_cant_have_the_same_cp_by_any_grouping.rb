cp, n = STDIN.gets.chomp!.split(" ").map{|v| v.to_i}
p "#{cp}, #{n}"

@memo = Hash.new(n)
def solve_1 cp_l, cp_h, n
  p "call solve: cp_l = #{cp_l}, cp_h = #{cp_h}, n = #{n}"
  return if n == 0

  (cp_l..cp_h-n).each do |cp|
    n.times do |i|
      @memo[i] += cp
    end
    solve cp + 1, cp_h, n - 1
  end
end

p solve 1, cp, n