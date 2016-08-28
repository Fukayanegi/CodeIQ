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
  divs.concat primes_1_9_tmp
end

n = STDIN.gets.chomp.to_i

# 1桁の数字で素因数分解
# 因数に2桁の数字がある場合空の配列が返る
primes_1_9 = factorize_prime_1_9 n

answer = 0
# 因数に2桁の数字がある時点で答えは0
puts answer if primes_1_9 == []

constitution = primes_1_9.inject(Hash.new{0}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
p constitution
# 一つの因数のみで構成されている平方数
answer += 1 if constitution.length == 1 && constitution.first[1] == 2

# 因数に2が3つ以上ある場合8を作成
# 作成した数字と残った数字の構成で作成可能な順列の数が有効
# 残った数字に2,3がある場合（6が作成可能な場合）は6を先に作成した場合に考慮される
if constitution[2] >= 3
  primes_1_9_tmp = multiply primes_1_9, [8]
  constitution_tmp = primes_1_9_tmp.inject({}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
  answer += primes_1_9_tmp.permutation(primes_1_9_tmp.length).to_a.length if constitution_tmp.all?{|k, v| v <= 1}
end

# 因数に2,3がある場合6を作成
# 残った数字に2が3つある場合8を作成
# 6を作成した後は2が1つか、2が3つ以上となるが、2が3つ以上となる場合は8を作成しないと222の数列が存在しNGになる
# 作成した数字と残った数字の構成で作成可能な順列の数が有効
if (constitution.include? 2) && (constitution.include? 3)
  primes_1_9_tmp = []
  if constitution[2] >= 4
    primes_1_9_tmp = multiply primes_1_9, [6, 8]
  else
    primes_1_9_tmp = multiply primes_1_9, [6]
  end

  constitution_tmp = primes_1_9_tmp.inject({}){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
  answer += primes_1_9_tmp.permutation(primes_1_9_tmp.length).to_a.length if constitution_tmp.all?{|k, v| v <= 1}
end

puts answer
