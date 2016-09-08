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

def solve smaller, bigger, choices
  return 1 if (smaller == 0 && bigger == 0)

  answer = 0
  if bigger > 0
    # 大きい数字を作れるか
    target = choices.select{|v| v <= bigger}.dup
    target.each do |choice_b|
      answer += solve smaller, bigger - choice_b, choices.select{|v| v < choice_b}
    end
  elsif bigger == 0
    # 小さい数字を作れるか
    target = choices.select{|v| v <= smaller}.dup
    target.each do |choice_s|
      answer += solve smaller - choice_s, bigger, choices.select{|v| v < choice_s}
    end
  end

  answer
end

make_primes m

answer = 0
((@primes.inject(:+) - n) / 2 + n).downto n do |bigger|
  answer += solve bigger - n, bigger, @primes
end

puts answer