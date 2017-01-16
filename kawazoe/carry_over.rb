def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

n, c = STDIN.gets.chomp.split(" ").map(&:to_i)
# n, c = 1, 1
# n, c = 1, 0
# n, c = 2, 0
# n, c = 2, 1
# n, c = 2, 2
# n, c = 3, 1
dlog({:n => n, :c => c})

def make_patterns
  patterns_co = []
  patterns_not_co = []
  (0..9).each do |num1|
    [0, 1].each do |co|
      (0..9).each do |num2|
        # dlog({:n1 => num1, :co => co, :n2 => num2})
        if num1 + num2 + co > 9
          patterns_co << [num1, co, num2]
        else
          patterns_not_co << [num1, co, num2]
        end
      end
    end
  end

  [patterns_co, patterns_not_co]
end

def count_patterns acc_patterns, previous_carry_over, carry_over, co_patterns
  tmp = acc_patterns.inject(Hash.new(0)) do |acc, (counts_of_carryover, count)|
    acc[counts_of_carryover] += count * co_patterns.select{|(num1, co, num2)| co == previous_carry_over}.length
    acc
  end

  answer = tmp.inject({}) do |acc, (k, v)|
    acc[carry_over] = acc[carry_over] || Hash.new(0)
    acc[carry_over][k] += v
    acc
  end
  # p answer
end

def count_carry_orver digits, count_of_carryover
  patterns_co, patterns_not_co = make_patterns

  answer_tmp = 1.upto(digits).inject(nil) do |acc, digit|
    if digit == 1
      {1 => {1 => patterns_co.select{|(num1, co, num2)| co == 0}.length}, 0 => {0 => patterns_not_co.select{|(num1, co, num2)| co == 0}.length}}
    else
      acc.inject({}) do |next_acc, (carry_over, counts_of_carryover)|
        dlog({:counts_of_carryover => counts_of_carryover})
        dlog({:next_acc => next_acc})

        # next_acc.merge!(count_patterns(counts_of_carryover, carry_over, 0, patterns_not_co))
        not_co_tmp = counts_of_carryover.inject(Hash.new(0)) do |co_acc, (co_count, count)|
          co_acc[co_count] += count * patterns_not_co.select{|(num1, co, num2)| co == carry_over}.length
          co_acc
        end
        dlog({:not_co_tmp => not_co_tmp})
        not_co_tmp.each do |k, v|
          next_acc[0] = next_acc[0] || Hash.new(0)
          next_acc[0][k] += v
        end

        # next_acc.merge!(count_patterns(counts_of_carryover, carry_over, 1, patterns_co))
        co_tmp = counts_of_carryover.inject(Hash.new(0)) do |co_acc, (co_count, count)|
          co_acc[co_count + 1] += count * patterns_co.select{|(num1, co, num2)| co == carry_over}.length
          co_acc
        end
        dlog({:co_tmp => co_tmp})
        co_tmp.each do |k, v|
          next_acc[1] = next_acc[1] || Hash.new(0)
          next_acc[1][k] += v
        end

        next_acc
      end
    end
  end
  dlog({:answer_tmp => answer_tmp})

  answer = answer_tmp.inject(Hash.new(0)){|acc, (co, h)| h.each{|(key, v)| acc[key] += v}; acc}
  dlog({:answer => answer})

  answer[count_of_carryover]
end

puts count_carry_orver(n, c)