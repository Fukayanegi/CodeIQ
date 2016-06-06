n = STDIN.gets.chomp.to_i

# 階乗を求める関数
def factorial(number)
  number = 0 if number.nil?
  (1..number).inject(1,:*)
end

def solve players
  return Rational(4,3) if players == 3

  # 全部のパターン数
  patterns = 2**players
  # AまたはBを1人が選ぶパターン数
  fin = players*2
  # playersが5人以上の場合は2人がAまたはBを選んでも終了
  fin += (players*(players-1)/2)*2 if players >= 5
  # 同数のA,Bとなる場合のパターン数
  # = 全員がAまたはB
  # += playersが偶数の場合にAまたはBをplayer/2が選んだ場合（AもBも同数になるため*2はしない）
  again = 2
  again += factorial(players) / (factorial(players / 2)**2) if players.even?

  # playersが変わらない場合のターン数の期待値
  # 等差*等比無限級数の和
  # S = 1 * Rational(fin, patterns) + 2 * Rational(fin, patterns) * Ratonal(again, atterns) + 3 * ...
  ratio1 = Rational(fin, patterns)
  ratio2 = Rational(again, patterns)
  e1 = ratio1/(1-ratio2)**2

  # player数が減る場合のターン数の期待値(players >= 7)
  e2 = 0
  (3..(players-1)/2).each do |winners|
    patterns_r = factorial(players) / (factorial(players - winners) * factorial(winners)) * 2
    ratio3 = Rational(patterns_r, patterns)
    # 以下を分解して考える
    # S = Rational(patterns_r, patterns) * (solve winners + 1)
    #  + Rational(again, patterns) + Rational(patterns_r, patterns) * (solve winners + 2) +
    #  + Rational(again, patterns)**2 + Rational(patterns_r, patterns) * (solve winners + 3) + ...
    e2 += ratio3*(solve winners)/(1-ratio2) if winners != players - winners
    e2 += ratio3/(1-ratio2)**2 if winners != players - winners
  end

  e1 + e2
end

answer = solve n
puts (answer*10**6).to_i