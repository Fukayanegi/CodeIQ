m, n = STDIN.gets.chomp.split(",").map{|v| v.to_i}

s = (1 + m) * m / 2

if s % n != 0 
  # 明らかに解がないケース
  puts 0
else
  # 1からmの数字でnになるパターン
  cards = (1..m).to_a
  patterns = []
  (1.upto m).each do |num_of_cards|
    ps = cards.combination(num_of_cards).select do |comb|
      comb.inject(:+) == s / n
    end
    patterns.concat ps
  end
  answers = patterns.combination(n).select do |comb|
    comb.flatten.sort == cards
  end
  puts answers.length
end