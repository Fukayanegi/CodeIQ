# 3進数のうちどの桁にも"2"を含まない数のパターン数が答え

def count_patterns_max_digit trit
  magnification = trit[0].to_i
  answer = magnification * 2 ** (trit.length - 1)
  # p "answer >> #{trit} : #{answer}"
  answer
end

def count_patterns trit
  # p "call count_patterns >> tirt : #{trit}"
  # 0 => 0
  # 1 => 0, 1
  # 2 => 0, 1
  return trit.to_i(3) + 1 if trit.to_i(3) < 2
  return 2 if trit.to_i(3) == 2
  
  # "22121"の場合、"20000"までと残り"2121"に分けてカウント
  # ただし、最上位桁が"2"の場合は残りの"2121"がいくつであっても、最上位桁が"2"のため、
  # カウントされないので計算しない
  max_digit = trit[0] + "0" * (trit.length - 1)
  rest = trit[1..trit.length - 1]
  # p "#{max_digit}, #{rest}"
  answer = 0
  answer += count_patterns rest if trit[0] != "2"
  answer += count_patterns_max_digit max_digit
  answer
end

n = STDIN.gets.chomp.to_i
trit = n.to_s(3)
# p "trit: #{trit}"
p count_patterns trit