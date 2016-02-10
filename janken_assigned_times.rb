coins_a, coins_b, max_tries = STDIN.gets.chomp!.split(',').map{|value| value.to_i}

@memo = Hash.new

MAX_TRIES = max_tries
COINS_FOR_WIN = coins_a+coins_b

def count_patterns coins, tries
  # 取得コインの数、残りゲーム回数をキーに結果をメモ化可能
  key = "#{coins}:#{MAX_TRIES-tries}"
  return @memo[key] if @memo.include? key
  return 1 if coins == 0 || coins == COINS_FOR_WIN
  return 0 if tries == MAX_TRIES

  answer = 0
  answer += count_patterns coins+1, tries+1 # 勝ち
  answer += count_patterns coins, tries+1   # 引き分け
  answer += count_patterns coins-1, tries+1 # 負け

  @memo[key] = answer
end

p count_patterns coins_a, 0
