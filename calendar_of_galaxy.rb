a1=[0,31,62,94,125,157,188,220,251,282,314]
a2=[0,31,62,94,125,156,187,219,250,281,313]
y,m,d=STDIN.gets.chomp.split(".")
y,d=y.to_i,d.to_i
l=y%20==0&&(y%80!=0||y%4000==0)
a=l ? a2 : a1
blc=1599/20-1599/80
lc=((y-1)/20)-((y-1)/80)+((y-1)/4000)
r=y>=1600 ? 5 : 0
puts (116+((y.to_i-500)*345+r-(lc-blc)+a[(m.ord-65)]+d.to_i-1)%7).chr
