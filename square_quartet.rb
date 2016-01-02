a, b = STDIN.gets.chomp.split(' ').map {|obj| obj.to_i }
diff = b**2-a**2

answer = []

fin = (diff+1)/2
x = Math.sqrt(diff).ceil

while x <= fin 
  d = Math.sqrt(x**2-diff)
  if d % 1 == 0
    answer << x.to_i
    answer << d.to_i

    terms = x-d-1
    break if terms <= 0 || x >= fin

    a = 0.1
    while (a % 1 != 0) && (x <= fin) && (terms > 0)
      a = (diff+terms**2-terms)/terms
      x = (a+1)/2
      # p "#{a}, #{x}, #{terms}, #{diff}, #{fin}"
      terms += -1
    end
  else
    x += 1
  end
end

puts answer.inject(:+)