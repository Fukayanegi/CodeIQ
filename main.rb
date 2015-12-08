def solve lor
  n = lor.to_i
  return { b:0, c:0 } if n <= 0
  return { b:1, c:1 } if n == 1

  if n > 1 then
    return { b:1, c:1 }
  end
end

limit_of_return = ARGV[0]
puts "INPUT : P = " + limit_of_return

answer_tmp = solve limit_of_return
answer = answer_tmp.values.inject(:+)

puts "ANSWER : N = " + answer.to_s

answer