cities = STDIN.gets.chomp.to_i

@memo = []
def solve cities
  return 1 if cities == 2
  return 3 if cities == 3
  return @memo[cities] if @memo.include? cities

  # 勝者決定
  answer = 1

  # 敗者決定
  answer += 1 * (solve cities-1)

  # 勝者未決敗者決選投票
  ((cities-1).downto 2).each do |losers|
    answer += (solve cities-1) * (solve losers)
  end

  @memo[cities] = answer
  answer
end

p solve cities