a, b, max_tries = STDIN.gets.chomp!.split(',').map{|value| value.to_i}

@memo = Hash.new
@route = Array.new
def num_of_pattern coins, coins_for_win, c_try, max_tries
  key = "#{c_try}:#{coins}:#{max_tries}"
  return @memo[key] if @memo.include? key

  return 1 if (coins == 1 || coins == coins_for_win-1) && max_tries == 1
  return 0 if (coins > max_tries) && (coins < coins_for_win - max_tries)

  answer = 0
  answer += num_of_pattern coins-1, coins_for_win, c_try+1, max_tries-1 if coins > 1
  answer += num_of_pattern coins+1, coins_for_win, c_try+1, max_tries-1 if coins < coins_for_win-1

  @memo[key] = answer
  answer
end

p "#{a}, #{b}, #{max_tries}"
p num_of_pattern a, a+b, 0, max_tries
p @memo