n, m = STDIN.gets.chomp.split(",").map{|v| v.to_i}

answer = "-"
(n-1).downto(0) do |num|
  pattern_of_num = num.to_s.each_char.to_a.uniq
  pattern_of_num_of_power = (num**m).to_s.each_char.to_a.uniq

  # p "#{num}, #{num**m}, #{pattern_of_num}, #{pattern_of_num_of_power}"

  next if pattern_of_num.length != pattern_of_num.length

  if pattern_of_num & pattern_of_num_of_power == []
    answer = num
    break
  end
end

puts answer