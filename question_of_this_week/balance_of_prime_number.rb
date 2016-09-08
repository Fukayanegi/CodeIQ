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

def solve smaller, bigger, choices_b, choices_s
  return 1 if (smaller == 0 && bigger == 0)

  answer = 0
  if bigger > 0
    # 大きい数字を作れるか
    target = choices_b.select{|v| v <= bigger}
    target.each do |choice_b|
      choices_s.delete choice_b
      # 2, 3 : 7 と 3, 2 : 7は同一ケースでありカウントを除外する必要があるためchoices_b.select{|v| v < choice_b}の制限を設ける
      answer += solve smaller, bigger - choice_b, choices_b.select{|v| v < choice_b}, choices_s
      choices_s.unshift choice_b
    end
  elsif bigger == 0
    # 小さい数字を作れるか
    target = choices_s.select{|v| v <= smaller}
    target.each do |choice_s|
      answer += solve smaller - choice_s, bigger, choices_b, choices_s.select{|v| v < choice_s}
    end
  end

  answer
end

make_primes m
# p @primes
# p @primes.inject(:+)

answer = 0
((@primes.inject(:+) - n) / 2 + n).downto n do |bigger|
  tmp = solve bigger - n, bigger, @primes, @primes.dup
  # p "smaller = #{bigger - n}, bigger = #{bigger}, answer = #{tmp}"
  answer += tmp
end

p answer