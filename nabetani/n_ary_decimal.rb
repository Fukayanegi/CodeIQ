input_strs = []
while line = STDIN.gets
  input_strs << line.chomp.split("\t")
end

input_strs.each do |line_no, exp, answer|
  p "#{line_no}, #{exp}, #{answer}"
end