command = STDIN.gets.chomp!.split(" ")
option = Hash.new
(2..command.length).each do |i|
  option[command[i]] = true
end

magnification = option.include?("-e") ? 2 : 1
question = option.include?("-q") ? "?" : ""
puts "sho" + ("hey" * (command[1].to_i * magnification)) + question