
@p, @q = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
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
    converted << num * 10 + v
  end
  converted.select{|v| v.odd? && v % 3 != 0 && v <= limit && (prime? v)}
end

def convert_2 num
  converted = []
  digit = num.to_s.length - 1
  return converted if digit < 1
  converted << num % 10**digit
  converted << num / 10
  if num > 99
    converted.select{|v| (v.odd?) && (v % 3 != 0) && (v > num / 100) && (prime? v)}
  else
    converted.select{|v| (v > num / 100) && (prime? v)}
  end
end

@loop_chek = {}
def solve p, q, num_convert
  return num_convert if p == q
  return nil if (@loop_chek.include? p) && (@loop_chek[p] < num_convert)
  return nil if (@loop_chek.include? q) && (@loop_chek[q] < num_convert)
  @loop_chek[p] = num_convert
  @loop_chek[q] = num_convert

  answers = []
  nums_1 = convert_1 p, @q
  nums_2 = convert_2 p
  nums_3 = convert_1 q, @q
  nums_4 = convert_2 q
  nums_from = nums_1.concat nums_2
  nums_to = nums_3.concat nums_4

  nums_from.each do |num|
    if nums_to.include? q
      answers << num_convert + 1
    elsif nums_to.include? num
      answers << num_convert + 2
    else
      nums_to.each do |target|
        # p "#{num}, #{target}, #{num_convert}"
        answer = solve num, target, num_convert + 2
        if !answer.nil?
          answers << answer
          break
        end
      end
    end
  end

  answer_tmp = answers.min
  answer_tmp
end

answer_tmp = solve @p, @q, 0
p (answer_tmp.nil? ? -1 : answer_tmp)