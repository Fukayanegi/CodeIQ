@m, @n = STDIN.gets.chomp.split(",").map{|v| v.to_i}

@nums = (1..@m).to_a
@s = (1 + @m) * @m / 2
# p s/n

@memo = {}
def seach select, patterns, i, rest
  return 1 if rest == 0
  answer = 0
  i.upto(patterns.length - 1) do |j|
    # p "#{select}, #{patterns}, #{patterns[j]}, #{i}, #{rest}"
    next if select & patterns[j] != 0
    answer += seach(select | patterns[j], patterns, j+1, rest-1)
  end
  answer
end

if @s % @n != 0 
  # 明らかに解がないケース
  puts 0
else
  # 1からmの数字でs/nになるパターン
  cards = (1..@m).to_a
  patterns = []
  (1.upto @m).each do |num_of_cards|
    ps = cards.combination(num_of_cards).select do |comb|
      comb.inject(:+) == @s / @n
    end

    patterns.concat ps.map{|p| p.inject(0){|acm, this| acm += 1 << (this-1)}}
  end

  puts seach 0, patterns, 0, @n
end