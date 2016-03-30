def display_matrix matrix
  matrix.each do |row|
    puts row.map{|col| "%03s" % col}.join("\t")
  end
end

def recommend_by_similarity item, matrix, c_user
  similarity = [[0, 0], [0, 0], [0, 0]]
  mole1 = matrix[item - 1][-1]
  target = matrix[item - 1]
  # パフォーマンスの観点から、下記のステップでコサイン類似度の分母を算出
  # 1. 評価値ごとに有効数字を持つ要素の添え字を抽出
  # 2. 評価値 * 掛け合わせる側の対象添え字を持つ要素の合計値

  # FIirbXME: 汎用的に
  one = []
  two = []
  three = []
  four = []
  five = []
  target.each_with_index{|val, i| one << i if val == 1}
  target.each_with_index{|val, i| two << i if val == 2}
  target.each_with_index{|val, i| three << i if val == 3}
  target.each_with_index{|val, i| four << i if val == 4}
  target.each_with_index{|val, i| five << i if val == 5}

  matrix.each_with_index do |row, i|
    if i != item - 1
      denomi = 0
      # FIirbXME: 汎用的に
      denomi += row.values_at(*one).inject(:+) if one.length > 0
      denomi += row.values_at(*two).inject(:+) * 2 if two.length > 0
      denomi += row.values_at(*three).inject(:+) * 3 if three.length > 0
      denomi += row.values_at(*four).inject(:+) * 4 if four.length > 0
      denomi += row.values_at(*five).inject(:+) * 5 if five.length > 0

      mole2 = row[-1]
      value = denomi / Math.sqrt(mole1 * mole2)

      # 上位3アイテムのみ保持する
      if value > similarity[0][1]
        if value > similarity[2][1]
          similarity << [i + 1, value]
          similarity.shift
        elsif value > similarity[1][1]
          similarity.insert(2, [i + 1, value])
          similarity.shift
        else
          similarity.shift
          similarity.unshift [i + 1, value]
        end
      end
    end
  end
  similarity.reverse
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
  # 事前計算
  matrix_rating_col[rating[1] - 1][-1] += rating[2] ** 2
end

# display_matrix matrix_rating_col

start = Time.now

c_recommend = STDIN.gets.chomp.to_i
c_recommend.times do
  item = STDIN.gets.chomp.to_i
  recommend = recommend_by_similarity item, matrix_rating_col, c_user
  # puts "#{item} #{recommend[0..2].map{|k, v| k.to_s + ':' + v.to_s}.join(" ")}"
  puts "#{item} #{recommend[0..2].map{|k, v| k}.join(" ")}"
end

# p  "#{Time.now - start}"