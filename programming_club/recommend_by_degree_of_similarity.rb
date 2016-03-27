def display_matrix matrix
  matrix.each do |row|
    p row.map{|col| "%03s" % col}.join(" ")
  end
end

def recommend_by_similarity item, matrix, c_user
  similarity = Hash.new
  matrix.each_with_index do |row, i|
    if i != item - 1
      denomi = 0
      mole1 = 0
      mole2 = 0
      c_user.times do |col|
        a = matrix[item - 1][col]
        b = row[col]
        denomi += a * b
        mole1 += a ** 2
        mole2 += b ** 2
      end
      similarity[i + 1] = denomi / (Math.sqrt(mole1) * Math.sqrt(mole2))
    end
  end
  similarity.sort{|(k1, v1), (k2, v2)| v2 <=> v1}
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
  recommend = recommend_by_similarity item, matrix_rating_col, c_user
  puts "#{item} #{recommend[0..2].map{|k, v| k}.join(" ")}"
end