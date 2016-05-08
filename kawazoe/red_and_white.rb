n = STDIN.gets.chomp.to_i

def calc_power_num n
  i = 1
  while 2**i < n
    i += 1
  end

  return i
end

def solve n
  # p "called solve #{n}"
  # sleep 1

  return 0.5 if n == 0
  return 1 if n == 1
  i = calc_power_num n

  is_even = n.even?
  rest = n - 2**(i-1)
  vertex = solve (is_even ? rest : rest - 1)

  # p "#{n}, #{i}, #{2**(i-1)}, #{is_even}, #{vertex}"

  return 1 if n == 2**i
  return 2 * vertex if is_even
  return 2 * 2 * vertex
end

answer = 2 * (solve n)
# p "answer: #{answer}"
puts answer.to_i