def factorize_prime_1_9 num
  primes = [2,3,5,7]
  answer = []
  primes.each do |prime|
    while num % prime == 0
      answer << prime
      num /= prime
    end
  end

  return answer if num == 1
  []
end

def multiply primes, divs
  sum = primes.inject(:*)
  divs.each do |div|
    sum /= div
  end
  primes_1_9_tmp = factorize_prime_1_9 sum
  answer = divs.concat primes_1_9_tmp
  # p answer
  answer
end

def is_valid sequence, additional
  # p "call is_valid: sequence = #{sequence}, additional = #{additional}"
  count = {additional => 1}
  answer = true
  (sequence.length).times do |i|
    num = sequence[sequence.length - 1 + i]
    count[num] = 0 if !count.include? num
    count[num] += 1
    if count.all?{|k, v| v.even?} && (i != sequence.length - 1)
      answer = false
      break
    end
  end

  # p "sequence = #{sequence}, additional = #{additional}, answer = #{answer}"
  answer
end

def count_patterns sequence, candidate_h
  candidate = candidate_h.select{|k, v| v > 0}.keys
  return 1 if candidate.length == 0
  answer = 0
  candidate.each do |k|
    if is_valid sequence, k
      candidate_h[k] -= 1
      sequence << k
      answer += count_patterns sequence, candidate_h
      sequence.pop
      candidate_h[k] += 1
    end
  end
  answer
end

n = STDIN.gets.chomp.to_i
answer = 0

if n > 0
  # 1桁の数字で素因数分解
  # 因数に2桁の数字がある場合空の配列が返る
  primes_1_9 = factorize_prime_1_9 n

  # 因数に2桁の数字がある時点で答えは0
  if primes_1_9 != []
    constitution = primes_1_9.inject(Hash.new{0}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
    # p constitution
    # 一つの因数のみで構成されている平方数
    answer += count_patterns [], constitution
    # p "1: #{answer}"

    constitution[3].times do |num|
      if constitution[2] >= num + 1
        primes_1_9_tmp = multiply primes_1_9, [6]*(num + 1)
        constitution_tmp = primes_1_9_tmp.inject({}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
        answer += count_patterns [], constitution_tmp
      end
    end
    # p "2: #{answer}"

    (constitution[2] / 3).times do |num|
      primes_1_9_tmp = multiply primes_1_9, [8]*(num + 1)
      constitution_tmp = primes_1_9_tmp.inject({}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
      answer += count_patterns [], constitution_tmp
    end
    # p "3: #{answer}"
  end
end

puts answer
