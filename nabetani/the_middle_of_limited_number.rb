limit_digits, numbers = STDIN.gets.chomp.split(" ")

count = 0
nums = []
(1..limit_digits.to_i).each do |digits|
  tmp = numbers.each_char.to_a.repeated_permutation(digits).to_a
  tmp.select!{|num| num[0] != "0"} if digits > 1
  count += tmp.length
  nums << tmp
end

targets = count.even? ? [count / 2 - 1, count / 2] : [count / 2]

answer = []
count = 0
nums.each do |num|
  prev = count
  count += num.length
  next if count <= targets[0]
  num = num.map{|v| v.join.to_i}.sort!

  if count > targets[0] + 1
    targets.each do |target|
      # p num[target -prev]
      answer << num[target - prev]
    end
  elsif count == targets[0] + 1
    # p num[targets[0] - prev]
    answer << num[tagets[0] - prev]
    targets.shift!
  end
end

puts answer.join(",")