n, m = STDIN.gets.chomp.split(",").map{|v| v.to_i}
digit = n.to_s.length

target = ("0".."9").to_a.permutation(digit).map{|num_a| num_a.join.to_i}.select{|num| num < n}

answer = "-"
target.sort{|a, b| b <=> a}.each do |num|
  pattern_of_num = num.to_s.each_char.to_a.uniq
  next if num.to_s.length != pattern_of_num.length
  
  pattern_of_num_of_power = (num**m).to_s.each_char.to_a.uniq

  # p "#{num}, #{num**m}, #{pattern_of_num}, #{pattern_of_num_of_power}"

  if pattern_of_num & pattern_of_num_of_power == []
    answer = num
    break
  end
end

puts answer