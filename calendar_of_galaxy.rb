a=[0,31,62,94,125,157,188,220,251,282,314]
y,m,d=STDIN.gets.chomp.split(".")
puts (116+((y.to_i-500)*345+a[(m.ord-65)]+d.to_i-1)%7).chr