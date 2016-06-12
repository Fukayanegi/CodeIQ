# Arrayを拡張
class Array
  def count
    k = Hash.new(0)
    self.each{|x| k[x] += 1 }
    return k
  end
end

cards = STDIN.gets.chomp.to_i
costs = STDIN.gets.chomp.to_i
status = {}
while line = STDIN.gets do
  cost, score = line.chomp.split(" ").map{|v| v.to_i}
  status[cost] = [] if !status.include? cost
  status[cost] << score
end

status.each do |cost, cards_by_cost|
  # p cards_by_cost
  cards_by_cost.sort!{|a, b| b <=> a}
end
# p status

# p "cards, #{cards}"
# p "costs, #{costs}"
# p "status, #{status}"

# カードの組み合わせを考える
patterns = []
(2..cards).each do |num_of_cards|
  patterns.concat status.keys.repeated_combination(num_of_cards).select{|comb| comb.inject(:+) <= costs}
end
# p patterns

# 組み合わせごとに、同一コストの中から最大のスコアを持つカードを選択する
score_tmp = 0
score_max = 0
patterns.each do |pattern|
  counts = pattern.count
  counts.each do |cost, count|
    if status[cost].length < count
      # そのコストのカードが足りない場合は組み合わせとして考えられないためスキップ
      score_tmp = 0
      next
    end
    score_tmp += status[cost].first(count).inject(:+)
  end
  score_max = score_tmp if score_tmp > score_max
  score_tmp = 0
end

p score_max