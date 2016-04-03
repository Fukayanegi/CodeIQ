def display board
  board.each do |row|
    p row.map{|c| "%3s" % c}.join(",")
  end
end

m, n = STDIN.gets.chomp.split(",").map{|v| v.to_i}
# p "#{m}, #{n}"

# 交点の配列
# 一番側に範囲外=-1を設定
board = Array.new(n + 3) do |i_row|
  if (1..(n + 1)).include? i_row
    Array.new(m + 3) do |i_col|
      ((1..(m + 1)).include? i_col) ? 0 : -1
    end
  else
    Array.new(m + 3) {-1}
  end
end
display board