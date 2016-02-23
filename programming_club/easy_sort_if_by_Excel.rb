class Score
  def initialize fields
    fields.each {|key, value| instance_variable_set("@#{key}", value)}
  end
end

class Solver
  def initialize header, socores
    @header = header
    @scores = socores
  end

  def solve
    @scores.sort! do |score1, score2|
      (score2.english <=> score1.english).nonzero? ||
      (score2.japanese <=> score1.japanese).nonzero? ||
      score2.math <=> score1.math
    end
  end

  def print
    puts @header.join(",")
    @scores.each do |score|
      line = ""
      @header.each do |subject|
        line << score.instance_variable_get("@#{subject}") + ","
      end
      puts line[0..-2]
    end
  end
end

# 1行目の文字列で動的にインスタンス変数を定義
header = STDIN.gets.chomp!.split(",")
Score.class_eval do
  header.each do |subject|
    attr_accessor subject.to_sym
  end
end

# 2行目以降の文字列で、subject => score のHash生成
scores = []
while line = STDIN.gets do
  values = line.chomp!.split(",")  
  fields = Hash.new
  header.each_with_index {|key, i| fields[key] = values[i] }

  scores << (Score.new fields)
end

solver = Solver.new header, scores
solver.solve
solver.print