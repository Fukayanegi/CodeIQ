def display_matrix matrix
  matrix.each do |row|
    p row.map{|col| "%03s" % col}.join(" ")
  end
end

input = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
c_user = input[0]
c_item = input[1]
c_rating = input[2]

matrix_rating_row = Array.new(c_user){Array.new(c_item){0}}
matrix_rating_col = Array.new(c_item){Array.new(c_user){0}}

c_rating.times do
  rating = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
  matrix_rating_row[rating[0] - 1][rating[1] - 1] = rating[2]
  matrix_rating_col[rating[1] - 1][rating[0] - 1] = rating[2]
end

display_matrix matrix_rating_row
display_matrix matrix_rating_col

c_recommend = STDIN.gets.chomp.to_i
c_recommend.times do
  item = STDIN.gets.chomp.to_i
  p matrix_rating_col[item - 1]
end