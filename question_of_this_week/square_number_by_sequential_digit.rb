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

n = STDIN.gets.chomp.to_i

# 1桁の数字で素因数分解
# 因数に2桁の数字がある場合空の配列が返る
primes_1_9 = factorize_prime_1_9 n

answer = 0
# 因数に2桁の数字がある時点で答えは0
puts answer if primes_1_9 == []

# 2,3,5,7のうちそれぞれ1つ以下の数字で構成されている場合、
# その構成で作成可能な順列の数が有効
constitution = primes_1_9.inject(Hash.new(0)){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
p constitution
answer += primes_1_9.permutation(primes_1_9.length).to_a.length if constitution.all?{|k, v| v <= 1}

#TODO: 以下のロジックをひとつにまとめられそうな気がする

# 因数に2,3がある場合6を作成し、残った数字の構成に2,3が同時に含まれていなければ
# 6と残った数字の構成で作成可能な順列の数が有効
primes_1_9_tmp = primes_1_9.dup
if constitution[2] == 1 && constitution[3] == 1
  primes_1_9_tmp.delete 2
  primes_1_9_tmp.delete 3
  primes_1_9_tmp << 6
  answer += primes_1_9_tmp.permutation(primes_1_9_tmp.length).to_a.length if constitution.all?{|k, v| v <= 1}
end
p primes_1_9_tmp

# 因数に2が3つ以上ある場合8を作成し、残った数字の構成がそれぞれ1つ以下で構成されている場合
# 8と残った数字の構成で作成可能な順列の数が有効
primes_1_9_tmp = primes_1_9.dup
if constitution[2] >= 3
  primes_1_9_tmp.delete 2
  (constitution[2] - 3).times{primes_1_9_tmp << 2}
  primes_1_9_tmp << 8
  constitution_tmp = primes_1_9_tmp.inject(Hash.new(0)){|acc, v| acc[v] = 0 if !acc.include? v; acc[v] += 1; acc}
  answer += primes_1_9_tmp.permutation(primes_1_9_tmp.length).to_a.length if constitution_tmp.all?{|k, v| v <= 1}
end
p primes_1_9_tmp

puts answer
