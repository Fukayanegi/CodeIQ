a, b = STDIN.gets.chomp.split(' ').map {|obj| obj.to_i }
diff = b**2-a**2
x = Math.sqrt(diff).ceil
y = Math.sqrt(x**2-diff)
answer = []

while y.ceil<x do 
  if y % 1 == 0
    answer << x
    answer << y.to_i
  end
  x += 1
  y = Math.sqrt(x**2-diff)
end

puts answer.inject(:+)