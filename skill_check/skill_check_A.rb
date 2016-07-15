coins = [500, 100, 50, 10, 5, 1]
n = STDIN.gets.chomp.to_i

def solve num, coins
  return 1 if coins.length == 1
  coin = coins.shift
  patterns = 0
  (num / coin + 1).times do |i|
    patterns += solve num - coin * i, coins
    # p "#{coin}, #{i}, #{patterns}"
  end
  coins.unshift coin
  patterns
end

puts solve n, coins