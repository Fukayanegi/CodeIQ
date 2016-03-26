def count_patterns_max_digit trit
  magnification = trit[0].to_i
  return magnification * 2 ** (trit.length - 1)
end

def count_patterns trit
  return trit.to_i(3) + 1 if trit.to_i(3) < 2
  return 2 if trit.to_i(3) == 2
  
  max_digit = trit[0] + "0" * (trit.length - 1)
  rest = trit[1..trit.length - 1]
  # p "#{max_digit}, #{rest}"
  answer = 0
  answer += count_patterns rest if trit[0] == "1"
  answer += count_patterns_max_digit max_digit
  answer
end

n = STDIN.gets.chomp.to_i
trit = n.to_s(3)
p count_patterns trit