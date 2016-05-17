n = STDIN.gets.chomp.to_i
cardinal = n

num = "10".to_i(n)
# p "init: #{num}"
while n > 0 do
  num_c = num.to_s(cardinal)
  len = num_c.length
  num_rev = num_c.each_char.to_a.inject(0){|acm, val| acm += val.to_i**len; acm}
  # p "#{num_rev}"
  if num_rev == num
    # p "#{num_c}, #{num}"
    puts num.to_s(cardinal)
    n -= 1
  end
  num += 1
end