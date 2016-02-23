# FIXME: dynamic define instance variable
class Score
  def initialize fields
    fields.each {|key, value| instance_variable_set("@#{key}", value)}
  end
end

header = STDIN.gets.chomp!.split(",")

Score.class_eval do
  header.each do |subject|
    attr_accessor subject.to_sym
  end
end

scores = []
while line = STDIN.gets do
  values = line.chomp!.split(",")
  
  fields = Hash.new
  header.each_with_index {|key, i| fields[key] = values[i] }

  scores << (Score.new fields)
end

scores.sort_by! do |score|
  [score.english, score.japanese, score.math]
end
p header
p scores