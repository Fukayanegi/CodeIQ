sequence = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

# フィボナッチ数列は最初に作ってしまう
@fibonacci = [1, 1]
@limit = 10000000000
num1 = @fibonacci[0]
num2 = @fibonacci[1]
while num1 + num2 <= @limit
  @fibonacci << num1 + num2
  num1, num2 = num2, num1 + num2
end
# p @fibonacci

def make_sq_cd first, second
  diff = second - first
  sq = []

  5.times do |t|
    sq << first + t * diff
  end
  sq
end

def make_sq_gmtc first, second
  ratio = Rational(second, first)
  sq = [first]

  (1..4).inject(first) do |acm, i|
    tmp = (acm * ratio).to_f
    break if tmp % 1 != 0
    sq << (acm * ratio).to_i
    tmp.to_i
  end
  sq
end

def make_sq_fb first, second
  idx = @fibonacci.find_index{|num| num == first}
  sq = []
  return sq if idx.nil?
  idx += 1 if (first == 1 && second != 1)

  sq = @fibonacci[idx..idx+4]
  sq
end

# 数列の初項、第２項を基準に、等差数列、等比数列、フィボナッチ数列を作成する
first, second = sequence[0..1]
sq1 = make_sq_cd first, second
sq2 = make_sq_gmtc first, second
sq3 = make_sq_fb first, second
# p sq1
# p sq2
# p sq3

# 一致していればその数列
if sequence == sq1
  puts "A"
elsif sequence == sq2
  puts "G"
elsif sequence == sq3
  puts "F"
else
  puts "x"
end
