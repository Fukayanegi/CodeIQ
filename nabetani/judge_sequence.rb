sequence = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

@fibonacci = [1, 1]
@limit = 10000000000
num1 = @fibonacci[0]
num2 = @fibonacci[1]
while num1 + num2 <= @limit
  @fibonacci << num1 + num2
  num1, num2 = num2, num1 + num2
end

def make_sq_cd first, second
  diff = second - first
  sq = []

  5.times do |t|
    sq << first + t * diff
  end
  sq
end

def make_sq_gmtc first, second
  ratio = second / first.to_f
  sq = []
  # return sq if second % first != 0

  5.times do |t|
    sq << (first * ratio ** t).round.to_i
  end
  sq
end

def make_sq_fb first, second
  idx = @fibonacci.find{|num| num == first}
  sq = []
  return sq if idx.nil?
  idx += 1 if second != @fibonacci[idx+1]

  sq = @fibonacci[idx-1..idx+5]
  sq
end

first, second = sequence[0..1]
sq1 = make_sq_cd first, second
sq2 = make_sq_gmtc first, second
sq3 = make_sq_fb first, second

# p @fibonacci
# p sq1
# p sq2
# p sq3

if sequence == sq1
  puts "A"
elsif sequence == sq2
  puts "G"
elsif sequence == sq3
  puts "F"
else
  puts "x"
end
