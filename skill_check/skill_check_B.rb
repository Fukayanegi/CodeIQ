n, m = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
digits = n.to_s(2).length

nums = (0..digits-1).to_a.combination(m).map do |comb|
  num = 0
  comb.each do |d|
    num += 1 << d
  end
  "%0#{digits}d" % num.to_s(2)
end

puts nums.select{|num| num.to_i(2) <= n}.length