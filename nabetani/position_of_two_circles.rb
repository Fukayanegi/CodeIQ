circles = STDIN.gets.chomp.split(" ").map{|circle| circle.split("/")}

circles.each do |circle|
  p circle
end