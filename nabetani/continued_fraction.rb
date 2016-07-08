input = STDIN.gets.chomp
nums = input.split("+").map{|num| num[1..-2].split(";")}.map{|num| [num[0].to_i, num[1].split(",").map{|v| v.to_i}]}

# 分数部分を抽出
fraction_a, fraction_b = nums.map do |num|
  x, y = 1, 0
  num[1].reverse.each{|v| x, y = y + x * v, x;}
  [y, x]
end

# 通分して足し算した分母(x)、分子(y)
y, x = fraction_a[0] * fraction_b[1] + fraction_b[0] *  fraction_a[1], fraction_a[1] * fraction_b[1]

# ユークリッド互除法適用
denominator = []
while y != 0 do
  # p "#{x}, #{y}"
  denominator << x / y
  x, y = y, x % y
end

# x == y の場合は整数部分の足し算に1を足すだけ
if denominator == [1]
  puts "#{nums[0][0] + nums[1][0] + 1}"
else
  puts "[#{nums[0][0] + nums[1][0]};#{denominator.join(",")}]"
end