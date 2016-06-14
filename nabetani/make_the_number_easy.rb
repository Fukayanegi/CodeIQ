input = STDIN.gets.chomp.split(",")
num_of_cards = input[0].to_i
target = input[1].to_i
cards = input[2].split("/").map{|v| v.to_i}

# p "#{num_of_cards}, #{target}, #{cards}"

if cards.select{|v| v != 0 }.length == 0
  puts "-"
else
  pattern = cards.permutation(num_of_cards)
  abs = pattern.inject({}) do |h, num|
    h[num.join.to_i] = (target - num.join.to_i).abs if !(num[0] == 0 && num.join.to_i != 0)
    h
  end
  # p abs.values.min

  min = abs.values.min
  puts abs.select{|key, value| key if value == min}.keys.join(",")
end