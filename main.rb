def solve lor, status
  n = lor.to_i
  return { b: 0, c: 0, x: 0 } if n <= 0
  return { b: 1, c: 1, x: 0 } if n <= 2

  if n > 2 then
    n = n - 1 if n.even?
    answer_tmp = solve n - 2, status
    new_b = answer_tmp[:b] * 1 + answer_tmp[:c] * 1 
    new_c = answer_tmp[:b] * 1 + answer_tmp[:c] * 2
    return { b: new_b, c: new_c, x: answer_tmp[:b] + answer_tmp[:c] + answer_tmp[:x] }
  end
end

limit_of_return = ARGV[0]
initial = { b:0, c:0 }
puts "INPUT : N = " + limit_of_return

answer_tmp = solve limit_of_return, initial
answer = answer_tmp.values.inject(:+)

puts "OUTPUT : P = " + answer.to_s

answer