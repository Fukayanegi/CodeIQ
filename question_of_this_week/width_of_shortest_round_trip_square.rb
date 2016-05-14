n = STDIN.gets.chomp.to_i

@memo_f = Hash.new
def factorial(number)
  number = 0 if number.nil?
  return @memo_f[number] if @memo_f.include? number
  @memo_f[number] = (1..number).inject(1,:*)
  @memo_f[number]
end

@memo_fp = Hash.new
def factorial_partial(from, to)
  return to if from == to

  key = "#{from}:#{to}"
  return @memo_fp[key] if @memo_fp.include? key
  @memo_fp[key] = factorial_partial(from + 1, to)
  @memo_fp[key]
end

answer = 0
width = n / 2
# while width != 1 do
(1..(n/2)).each do |width|
  height = n - width
  # routes = factorial(n) / (factorial(width) * factorial(n - width))
  mother = factorial_partial(width + 1, n)
  child = factorial(width)
  routes = mother / child

  p "#{mother}, #{child}, #{routes}"
  if routes.even?
    answer = width
    break
  end
end

puts answer