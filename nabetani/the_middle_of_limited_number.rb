limit_digits, numbers = STDIN.gets.chomp.split(" ")
@including_zero = !numbers.index("0").nil?

# 全体の数の数え上げ
total_count = 0
@count_by_digits = {}
(1..limit_digits.to_i).each do |digits|
  tmp = numbers.length ** digits
  tmp -= numbers.length ** (digits - 1) if @including_zero && digits > 1
  total_count += tmp

  @count_by_digits[digits] = tmp
end

# 真ん中の数のindexを求める
targets = total_count.even? ? [total_count / 2 - 1, total_count / 2] : [total_count / 2]
# p @count_by_digits
# p "#{total_count}, #{targets}"

def solve digits, numbers, target, highest_zero
  # p "call solve #{digits}, #{numbers}, #{target}"
  return "" if digits < 1
  return numbers.each_char.sort[target] if digits == 1

  is_amp = @including_zero && numbers.length > 1 && digits > 2
  count = is_amp ? @count_by_digits[digits - 1] / (numbers.length - 1) * numbers.length : @count_by_digits[digits - 1]
  idx = target / count

  highest_digit = numbers.each_char.select{|c| highest_zero || c != "0"}.sort[idx]
  rest_target = target - count * idx
  highest_digit + (solve digits - 1, numbers, rest_target, true)
end

answer = []
targets.each do |target|
  total_count = 0
  digits = 0
  while total_count <= target
    digits += 1
    prev = total_count
    total_count += @count_by_digits[digits]
    rest_count = target - prev
  end
  answer << (solve digits, numbers, rest_count, false)
end

puts answer.join(",")
