a, b = STDIN.gets.chomp.split(' ').map {|obj| obj.to_i }
p "#{a}, #{b}"
diff = b**2-a**2
init = Math.sqrt(diff).ceil
p init

