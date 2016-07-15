num = []
num << STDIN.gets.chomp.to_i
num.concat STDIN.gets.chomp.split(" ").map{|v| v.to_i}

answer = false
num.combination(2).each{|n, m| answer = n + m == 256; break if answer}
puts answer ? "yes" : "no"