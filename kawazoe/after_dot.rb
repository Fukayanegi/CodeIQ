n = STDIN.gets.chomp.to_i

def judge_all_finite_decimal num
  return true if (num == 1) || (num == 2) || (num == 5)
  return true if num % 5 == 0 && judge_all_finite_decimal(num / 5)
  return true if num % 2 == 0 && judge_all_finite_decimal(num / 2)
  return false
end

def calc_factor_excepting_25 num
  while true do
    if num % 2 == 0
      num = num / 2
    elsif num % 5 == 0
      num = num / 5
    else
      break
    end
  end
  return num
end

answer = 0
1.upto n do |denominator|
  if judge_all_finite_decimal denominator
    answer += n
  else
    answer += n / (calc_factor_excepting_25 denominator)
  end
end

puts answer