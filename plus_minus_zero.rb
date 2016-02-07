n = STDIN.gets.chomp!.to_i

def num_of_zero_pattern n, target
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
  answer
end

target = n*(n+1)/2/2
p num_of_zero_pattern n, target