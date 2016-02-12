input = Hash.new
first = STDIN.gets.chomp!
9.times do
  key, value = STDIN.gets.chomp!.split(",")
  input[key] = value
end

def count_menber_of_retire first_retired, members
  retired = [first_retired]

  while members.select {|k, v| retired.include? v}.count != 0 do
    retired_tmp = members.select {|k, v| retired.include? v}.keys
    members.select! {|k, v| !(retired.include? v)}
    retired = retired_tmp
    # p "retired: #{retired}"
  end

  members.count
end

puts count_menber_of_retire first, input