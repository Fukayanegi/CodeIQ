n = STDIN.gets.chomp.to_i

def solve n
  # p "called solve #{n}"

  return 0.5 if n == 0

  i = 1
  while 2**i < n
    i += 1
  end

  is_even = n.even?
  rest = n - 2**(i-1)
  vertex = solve (is_even ? rest - 1 : rest)

  # p "#{i}, #{2**(i-1)}, #{is_even}, #{vertex}"

  return 1 if n == 2**i
  return 2 * vertex
end

answer = 2 * (solve n)
# p "answer: #{answer}"
puts answer.to_i