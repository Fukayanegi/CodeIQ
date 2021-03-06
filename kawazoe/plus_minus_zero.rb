n = STDIN.gets.chomp!.to_i
@memo = Hash.new

def num_of_zero_pattern n, target
  key = "#{n}:#{target}"
  return @memo[key] if @memo.include? key

  return 0 if target > n*(n+1)/2 || n <= 0 || target <= 0
  return 1 if target == n*(n+1)/2

  answer = 0
  if target <= n
    answer += 1
    answer += num_of_zero_pattern target-1, target
  else
    (1..n).to_a.reverse.each do |i|
      answer += num_of_zero_pattern i-1, target-i
    end
  end

  @memo[key] = answer
  answer
end

target = n*(n+1)/2/2
if n.to_f*(n+1) % 4 == 0 then
  p num_of_zero_pattern n, target
else
  p 0
end