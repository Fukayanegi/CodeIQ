n = STDIN.gets.chomp.to_i

def factorial(number)
  number = 0 if number.nil?
  (1..number).inject(1,:*)
end

answer = 0
(1..(n/2)).each do |width|
  height = n - width
  routes = factorial(n) / (factorial(width) * factorial(n - width))
  p "#{width}, #{routes}"
  if routes.even?
    answer = width
    break
  end
end

puts answer