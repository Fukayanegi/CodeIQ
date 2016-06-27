input = STDIN.gets.chomp.split(",")
num_of_cards = input[0].to_i
target = input[1].to_i
cards = input[2].split("/").map{|pair| pair.each_char.to_a.map{|num| num.to_i}}

# p "#{num_of_cards}, #{target}, #{cards}"

if cards.select{|v| v[0] != 0 || v[1] != 0}.length == 0
  puts "-"
else
  pattern = cards.permutation(num_of_cards)
  abs = pattern.inject({}) do |h, num|
    key = Array.new(num_of_cards){0}
    num_of_cards.times do |i_card|
      key[i_card] = num[i_card][0]
      table = (target - key.join.to_i).abs
      key[i_card] = num[i_card][1]
      back = (target - key.join.to_i).abs
      
      side = table < back ? 0 : 1
      side = 1 if num[i_card][0] == 0 && num_of_cards > 1 && i_card == 0
      side = 0 if num[i_card][1] == 0 && num_of_cards > 1 && i_card == 0
      key[i_card] = num[i_card][side]
    end

    num_abs_min = key.join.to_i
    h[num_abs_min] = (target - num_abs_min).abs if !(key[0] == 0 && num_abs_min != 0)
    h
  end
  # p abs.values.min

  min = abs.values.min
  puts abs.select{|key, value| key if value == min}.keys.join(",")
end