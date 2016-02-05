@days = STDIN.gets.chomp!.to_i

def count_monster o, t, f, s, e, days
  puts 1
  days.times do
    o, t, f, s, e = e + s, o + s, t, e, f
    puts o+t+f+s+e
  end
end

count_monster 1, 0, 0, 0, 0, @days-1
