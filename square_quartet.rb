a, b = STDIN.gets.chomp.split(' ').map {|obj| obj.to_i }
diff = b**2-a**2

answer = []

fin = (diff+1)/2
(2..fin).each do |x|
  if 4*x**2-4*diff > 0
    d = Math.sqrt(4*x**2-4*diff)
    sol1, sol2 = (2*x+d)/2, (2*x-d)/2
    if x-sol1 > 0 && sol1 % 1 == 0
      answer << x.to_i
      answer << (x-sol1).to_i
    end
    if x-sol2 > 0 && sol2 % 1 == 0
      answer << x
      answer << (x-sol2).to_i
    end
  end
end

puts answer.inject(:+)