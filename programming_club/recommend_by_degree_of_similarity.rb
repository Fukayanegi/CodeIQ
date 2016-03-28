def display_matrix matrix
  matrix.each do |row|
    puts row.map{|col| "%03s" % col}.join("\t")
  end
end

def recommend_by_similarity item, matrix, c_user
  similarity = Hash.new
  # mole1 = matrix[item - 1].inject(0){|acm, val| acm += val ** 2}
  mole1 = matrix[item - 1][-1]
  matrix.each_with_index do |row, i|
    if i != item - 1
      denomi = 0
      # mole2 = 0
      mole2 = row[-1]
      c_user.times do |col|
        denomi += matrix[item - 1][col] * row[col]
        # a = matrix[item - 1][col]
        # b = row[col]
        # denomi += a * b
        # mole2 += b ** 2
      end
      similarity[i + 1] = denomi / Math.sqrt(mole1 * mole2)
      # p "#{i+1} : #{denomi}, #{mole1}, #{mole2}"
    end
  end
  # p similarity.sort{|(k1, v1), (k2, v2)| v2 <=> v1}
  similarity.sort{|(k1, v1), (k2, v2)| (v2 <=> v1).nonzero? || (k1 <=> k2)}
end

input = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
c_user = input[0]
c_item = input[1]
c_rating = input[2]

# 商品ごとに最後の1項目はuser|a->|の値とする
matrix_rating_col = Array.new(c_item){Array.new(c_user + 1){0}}

c_rating.times do
  rating = STDIN.gets.chomp.split(" ").map{|val| val.to_i}
  matrix_rating_col[rating[1] - 1][rating[0] - 1] = rating[2]
end

# display_matrix matrix_rating_row
# display_matrix matrix_rating_col

start = Time.now

#️ 事前計算
matrix_rating_col.each do |row|
  row[-1] = row.inject(0){|acm, val| acm += val **2}
end

# display_matrix matrix_rating_col

c_recommend = STDIN.gets.chomp.to_i
c_recommend.times do
  item = STDIN.gets.chomp.to_i
  recommend = recommend_by_similarity item, matrix_rating_col, c_user
  # puts "#{item} #{recommend[0..2].map{|k, v| k.to_s + ':' + v.to_s}.join(" ")}"
  puts "#{item} #{recommend[0..2].map{|k, v| k}.join(" ")}"
end

p  "#{Time.now - start}"