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
  @memo_fp[key] = from * factorial_partial(from + 1, to)
  @memo_fp[key]
end

answer = 0
width = 1
while width <= n / 2 do
  # 最短距離の場合の数は、factorial(n) / (factorial(width) * factorial(n - width))
  # この値が偶数になるケースはwidthの増分に対応する場合の数への乗数(height + 1) / widthが偶数になる場合のみ
  # なぜなら1つ前のwidthでfactorial(n) / (factorial(width) * factorial(n - width))が奇数だった場合、
  # 現在の(height + 1) / widthが奇数の場合は、奇数*奇数で奇数となる
  # 現在の(height + 1) / widthが割り切れない場合、奇数*(height + 1)となるが、
  # (height + 1)が偶数ということは、割り切れなかったwidthは奇数、heightも奇数だが、この場合
  # width + heightが偶数となり、width = 1でfactorial(n) / (factorial(width) * factorial(n - width))が偶数になるはず
  # なのでありえない

  height = n - width
  # routes = factorial(n) / (factorial(width) * factorial(n - width))
  # mother = factorial_partial(height + 1, n)
  # child = factorial(width)
  # routes = mother / child
  routes = (height + 1) / width
  mod = (n - width + 1) % width

  # p "#{width}, #{mother}, #{child}, #{routes}"
  # p "#{width}, #{routes}, #{mod}"
  # sleep(2)
  if routes.even? && mod == 0
    answer = width
    break
  end
  width += 1
end

puts answer