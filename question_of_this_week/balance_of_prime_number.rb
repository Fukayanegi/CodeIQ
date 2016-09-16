require 'set'
m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

# 素数配列作成
@primes = []
@limit = 1
def make_primes limit
  ((@limit+1)..limit).each do |num|
    is_prime = true
    quotient = limit
    @primes.each do |prime|
      # 判定対象が前回判定時の商を超える素数だった場合、
      # 以降の商は前回の素数を下回る（既に存在しないことが判定済）ため打ち切り
      if prime > quotient
        is_prime = true
        break
      end
      quotient = num / prime
      if num % prime == 0
        is_prime = false
        break
      end
    end
    @primes << num if is_prime
  end
  @limit = limit
end

make_primes m
sum_all = @primes.inject(:+)
bit_length = @primes.max

def create_bits numbers, length
  key = 0
  numbers.each do |num|
    key += 1 << (num - 1)
  end
  key
end

@memo = {0 => [0], sum_all => (create_bits @primes, bit_length)}
1.upto(@primes.length / 2) do |less|
  @primes.combination(less).each do |choices_l|
    key = choices_l.inject(:+)
    if !@memo.include? key
      @memo[key] = []
      @memo[sum_all - key] = []
    end
    @memo[key] << (create_bits choices_l, bit_length)
    @memo[sum_all - key] << (create_bits @primes - choices_l, bit_length) if less != @primes.length - less
  end
end

answer = 0
((sum_all - n) / 2 + n).downto n do |bigger|
  tmp_b = @memo.include?(bigger) ? @memo[bigger] : []
  tmp_b.each do |choices_b|
    tmp_l = @memo.include?(bigger - n) ? @memo[bigger - n] : []
    tmp_l.each do |choices_l|
      if (choices_b & choices_l) == 0
        answer += 1
      end
    end
  end
end
p answer
