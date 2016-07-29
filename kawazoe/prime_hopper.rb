
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

num_convert = 0
loop_chek_from = {@p => 0}
loop_chek_to = {@q => 0}
nums_from_all = [@p]
nums_to_all = [@q]

while true do
  nums_from_next = []
  nums_to_next = []

  if nums_from_all.length == 0 || nums_to_all.length == 0
    found = true
    num_convert = -1
  end

  nums_from_all.each do |from|
    from_tmp = (convert_1 from, @q).concat (convert_2 from)
    nums_from_next.concat from_tmp.select{|f| !(loop_chek_from.include? f)}
  end

  nums_to_all.each do |to|
    to_tmp = (convert_1 to, @q).concat (convert_2 to)
    nums_to_next.concat to_tmp.select{|t| !(loop_chek_to.include? t)}
  end

  nums_from_next.each do |from|
    if nums_to_all.include? from
      found = true
      num_convert += 1
      break
    end
  end

  nums_from_next.each do |f|
    nums_to_next.each do |t|
      if f == t
        found = true
        num_convert += 2
        break
      end
    end
    break if found
  end

  break if found

  nums_from_next.each do |f|
    loop_chek_from[f] = num_convert
  end
  nums_to_next.each do |t|
    loop_chek_to[t] = num_convert
  end

  nums_from_all = nums_from_next
  nums_to_all = nums_to_next
  num_convert += 2
end

answer_tmp = num_convert
p (answer_tmp.nil? ? -1 : answer_tmp)