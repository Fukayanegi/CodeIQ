n, m = STDIN.gets.chomp.split(",").map{|v| v.to_i}

answer = "-"
n.downto(0) do |num|
  num_p = num.to_s.each_char.to_a.uniq
  num_of_power_p = (num**m).to_s.each_char.to_a.uniq

  if num_p & num_of_power_p == []
    answer = num
    break
  end
end

puts answer