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

def solve_under_digits digits, numbers, target, highest_zero
  # p "call solve_under_digits #{digits}, #{numbers}, #{target}"
  return "" if digits < 1
  return numbers.each_char.sort[target] if digits == 1

  is_amp = @including_zero && numbers.length > 1 && digits > 2
  count = is_amp ? @count_by_digits[digits - 1] / (numbers.length - 1) * numbers.length : @count_by_digits[digits - 1]
  # p "digits = #{digits - 1}, count_by_digits = #{@count_by_digits[digits - 1]}, count = #{count}"
  idx = target / count
  # p "idx = #{idx}"

  highest_digit = numbers.each_char.select{|c| highest_zero || c != "0"}.sort[idx]
  repeat_digit = numbers.each_char.sort[0]

  rest_target = target - count * idx
  rest_target = count - 1 if rest_target < 0

  highest_digit + (solve_under_digits digits - 1, numbers, rest_target, true)
end

def solve digits, numbers, targets
  # p "call solve #{digits}, #{numbers}, #{targets}"
  answer = []

  if digits == 1
    targets.each do |target|
      answer << numbers.each_char.to_a[target]
    end
    return answer
  end

  total_count = 0

  1.upto(digits) do |i_digits|
    prev = total_count
    total_count += @count_by_digits[i_digits]
    next if total_count <= targets[0]
    # i_digits桁に解がある
    # p "digits = #{digits}, i_digits = #{i_digits}, target = #{targets}, total = #{total_count}"

    # 2つ目の解がちょうど桁変わりだった場合
    # 直接求めてもよい
    if total_count == targets[0] + 1 && targets.length > 1
      answer.concat (solve i_digits + 1, numbers, [targets[1]])
      # p "2nd_answer: #{answer}"
      targets.pop
    end

    targets.length.times do |i_rest|
      rest_count = targets[0] + i_rest - prev

      if i_digits == 1
        answer << (solve_under_digits 1, numbers, rest_count, true)
      else
        answer << (solve_under_digits i_digits, numbers, rest_count, false)
      end
    end

    break
  end
  answer.map{|num| num.to_i}.sort.map{|num| num.to_s}
end

puts (solve limit_digits.to_i, numbers, targets).join(",")
