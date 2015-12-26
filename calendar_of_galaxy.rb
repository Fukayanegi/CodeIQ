w = %w(t u v w x y z)
ajst = [0,0,0,1,1,2,2,3,3,3,4]
y,m,d = STDIN.gets.chomp.split(".")
# p (y.to_i-500)*345+(m.ord-65)*31+ajst[m.ord-65]+d.to_i
p w[((y.to_i-500)*345+(m.ord-65)*31+ajst[m.ord-65]+d.to_i-1)%7]