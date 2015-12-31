a, b = STDIN.gets.chomp.split(' ').map {|obj| obj.to_i }
diff = b**2-a**2

answer = []

fin = (diff+1)/2
p "#{fin}"
x = 2

while x <= fin do 
  if x**2-diff > 0
    d = Math.sqrt(x**2-diff)
    if d % 1 == 0
      sol1, sol2 = x+d, x-d
      if x-sol1 > 0
        answer << x.to_i
        answer << (x-sol1).to_i
      end
      if x-sol2 > 0
        answer << x
        answer << (x-sol2).to_i
      end
    else
      # while !(((x+1)**2-diff) % 1 == 0) do
      #   x += 1
      # end
    end
    # p "#{x}, #{sol1}, #{sol2}"
  end

  x += 1
end

puts answer.inject(:+)