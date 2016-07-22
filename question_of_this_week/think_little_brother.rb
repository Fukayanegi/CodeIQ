params = STDIN.gets.chomp.split(",").map{|v| v.to_i}
cols = params[0]
rows = params[1]
brothers = params[2]
# p "#{cols}, #{rows}, #{brothers}"

def solve cols, rows, brothers
  return 1 if brothers == 0
  patterns = 0

  (1..cols-1).each do |col|
    patterns += solve cols - col, rows, brothers - 1
  end

  (1..rows-1).each do |row|
    patterns += solve cols, rows - row, brothers - 1
  end

  patterns
end

puts (solve cols, rows, brothers - 1)