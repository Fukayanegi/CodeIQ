# 入力値の処理
talks = STDIN.gets.chomp.split(",").map do |talk|
  t = talk.scan(/([a-zA-Z]*):([a-zA-Z]*)(\d*)/)[0]
  [t[0], t[1].each_char.to_a, t[2].to_i]
end
kyura_max = talks.each.inject(0){|acc, talk| acc = talk[2] if acc < talk[2]; acc}
persons = talks.map{|talk| talk[0]}
# p "#{kyura_max}, #{persons.join}"

answer = []
# キュラ族のパターンごとに、下記の判定
# キュラ族の場合、発言が真
# ラゲ族の場合、発言が偽
(0..kyura_max).each do |kyuras_num|
  persons.combination(kyuras_num).each do |kyuras|
    # p "start: #{kyuras.join}"
    judge = true
    talks.each do |talk|
      r = talk[1].inject(0){|acc, person| acc = acc + 1 if (kyuras.include? person); acc}
      talk_judge = kyuras.include? talk[0]

      # キュラ族の発言が偽、ラゲ族の発言が真の場合、このキュラ族のパターンではない
      if (r == talk[2].to_i) != talk_judge
        # p "missmatch: #{kyuras.join}, #{talk_judge}, #{(r == talk[2])}, #{r}"
        judge = false
        break
      end
    end

    answer << kyuras if judge
  end
end

if answer.length == 0
  puts "none"
elsif answer.length > 1
  puts "many"
else
  k = answer[0].sort.join
  puts k == "" ? "-" : k
end
