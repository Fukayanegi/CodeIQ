
p, q = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
# p "#{p}, #{q}"

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

def prime? num
  if num > @limit
    make_primes num
  end
  @primes.include? num
end

def convert_1 num, limit
  converted = []
  left = num.to_s.length
  (1..9).each do |v|
    converted << v * 10**left + num
    converted << v + num * 10
  end
  converted.select{|v| v <= limit && (prime? v)}
end

def convert_2 num
  converted = []
  digit = num.to_s.length - 1
  return converted if digit < 1
  converted << num % 10**digit
  converted << num / 10
  converted.select{|v| prime? v}
end

@loop_chek = {}
def solve p, q, num_convert
  return nil if (@loop_chek.include? p) && (@loop_chek[p] <= num_convert)
  @loop_chek[p] = num_convert

  if p == q
    # p p if num_convert == 6
    return num_convert
  end

  answers = []
  nums_1 = convert_1 p, q
  nums_2 = convert_2 p
  nums = nums_1.concat nums_2
  # p num_convert
  nums.each do |num|
    answer = solve num, q, num_convert + 1
    if !answer.nil?
      # p num if answer == 6
      answers << answer 
    end
  end

  answers.min
end

make_primes q
# p @primes

answer_tmp = solve p, q, 0
p (answer_tmp.nil? ? -1 : answer_tmp)