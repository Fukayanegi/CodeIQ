class Score
  def initialize fields
    fields.each {|key, value| instance_variable_set("@#{key}", value)}
  end
end

header = STDIN.gets.chomp!.split(",")

# 1行目の文字列で動的にインスタンス変数を定義
Score.class_eval do
  header.each do |subject|
    attr_accessor subject.to_sym
  end
end

scores = []
while line = STDIN.gets do

  # subjest => score のHash生成
  values = line.chomp!.split(",")  
  fields = Hash.new
  header.each_with_index {|key, i| fields[key] = values[i] }

  scores << (Score.new fields)
end

scores.sort_by! do |score|
  [score.english, score.japanese, score.math]
end

puts header.join(",")
scores.each do |score|
  line = ""
  header.each do |subject|
    line << score.instance_variable_get("@#{subject}") + ","
  end
  puts line[0..-2]
end