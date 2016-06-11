seats, city = STDIN.gets.chomp.split(",").map{|num| num.to_i}
population = []
city.times do
  population << STDIN.gets.chomp.to_i
end

# p "#{seats}, #{city}"
# population.each{|pp| p pp}

div_num = population.inject(0){|max, this| max > this ? max : this}
?p "#{div_num}"

seats_adams = 0
delta = div_num
while seats_adams != seats do
  seats_adams = 0
  population.each do |this|
    seats_adams += (this / div_num.to_f).ceil
  end
  delta = delta / 2
  div_num = div_num - delta if seats_adams < seats
  div_num = div_num + delta if seats_adams > seats
  # p "#{div_num}, #{seats_adams}"
end

population.each{|pp| puts (pp / div_num.to_f).ceil}