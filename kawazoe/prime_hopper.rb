@primes = []
def prime? num
  return true if @primes.include? num
  prime = true
  (2..num/2).each do |denomi|
    prime = num % denomi != 0
    break if !prime
  end
  @primes << num if prime
  prime
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

p, q = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

@loop_chek = {}
def solve p, q, num_convert
  return nil if (@loop_chek.include? p) && (@loop_chek[p] <= num_convert)
  @loop_chek[p] = num_convert

  return num_convert if p == q

  answers = []
  nums_1 = convert_1 p, q
  nums_2 = convert_2 p
  nums = nums_1.concat nums_2
  # p num_convert
  nums.each do |num|
    answer = solve num, q, num_convert + 1
    answers << answer if !answer.nil?
  end

  answers.min
end

answer_tmp = solve p, q, 0
p (answer_tmp.nil? ? -1 : answer_tmp)