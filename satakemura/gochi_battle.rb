target = STDIN.gets.chomp.to_i
menu = []
while line = STDIN.gets do
  menu << line.chomp.to_i
end

total = menu.inject(:+)
surplus = total - target

p "target: #{target}, total: #{total}, surplus: #{surplus}"
p menu

if target > surplus
  target = surplus
end

p "target: #{target}"

min = target
1.upto(menu.length) do |num|
  diffs = []
  menu.combination(num).each do |comb|
    diffs << target - comb.inject(:+)
  end

  min_tmp = diffs.map{|v| v.abs}.min
  min = min_tmp if min_tmp < min
  break if min == 0
  break if diffs.all?{|val| val < 0}
  p "min: #{min}"
end

p min