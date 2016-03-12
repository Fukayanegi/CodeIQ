def adjust_value value, myself, enemy
  return value if myself == enemy
  return value * 2 if (myself - enemy == 1) || (myself == 0 && enemy == 2)
  return value / 2 if (myself - enemy == -1) || (myself == 2 && enemy == 0)
end

attribute = STDIN.gets.chomp
attribute = attribute == "F" ? 0 : attribute == "W" ? 1 : 2
values = STDIN.gets.chomp.split(" ").each_with_index.map{|val, i| adjust_value(val.to_i, i, attribute)}

# p attribute
# p values

ATTRIBUTE = ["F", "W", "T"]
answer = []
values.each_with_index do |val, i|
  answer << ATTRIBUTE[i] if val == values.max
end
puts answer.join
# p values.inject([]){|ary, val| ary << val if val == values.max; ary}