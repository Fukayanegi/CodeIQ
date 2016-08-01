m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

min_votes_limit = n / m

def patterns sum, num, min
  return 1 if sum >= min && num == 1
  return 0 if sum < min
  limit = sum / num
  answer = 0
  (min..limit).each do |votes|
    tmp = patterns sum - votes, num - 1, votes
    answer += tmp
  end
  answer
end

answer = 0
(1..min_votes_limit).each do |min_votes|
  # p "minvotes: #{min_votes}"
  if n % min_votes == 0
    rest = n / min_votes - 1
    # p "rest: #{rest}"
    if rest >= m - 1
      tmp = patterns rest, m - 1, 1
      # p "#{rest}, #{m-1}, #{min_votes}: #{tmp}" if tmp > 0
      answer += tmp
    end
  end
end

p answer