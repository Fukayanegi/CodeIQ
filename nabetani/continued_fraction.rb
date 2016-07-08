input = STDIN.gets.chomp
nums = input.split("+").map{|num| num[1..-2].split(";")}.map{|num| [num[0].to_i, num[1].split(",").map{|v| v.to_i}]}

fraction_a, fraction_b = nums.map do |num|
  x, y = 1, 0
  num[1].reverse.each{|v| x, y = y + x * v, x;}
  [y, x]
end

y, x = fraction_a[0] * fraction_b[1] + fraction_b[0] *  fraction_a[1], fraction_a[1] * fraction_b[1]
denominator = []
while y != 0 do
  # p "#{x}, #{y}"
  denominator << x / y
  x, y = y, x % y
end

if denominator == [1]
  puts "#{nums[0][0] + nums[1][0] + 1}"
else
  puts "[#{nums[0][0] + nums[1][0]};#{denominator.join(",")}]"
end