require 'set'

LINES = [[0,1,2,3,4],[5,6,7,8,9],[10,11,12,13,14],[15,16,17,18,19],[20,21,22,23,24], \
  [0,5,10,15,20],[1,6,11,16,21],[2,7,12,17,22],[3,8,13,18,23],[4,9,14,19,24], \
  [0,6,12,18,24],[4,8,12,16,20]]

cards = []
while line_in = STDIN.gets
  tmp = line_in.chomp.split(",").map{|val| val.to_i}
  card = []
  LINES.each do |line|
    card << tmp.values_at(*line)
  end
  cards << card
end

@answer = 25 * cards.length
def shortest cards, selection
  if cards.length == 0
    if selection.length < @answer
      @answer = selection.length
    end
    return
  end
  card = cards.shift
  card.each do |line|
    tmp = selection.union line
    if tmp.length > @answer
      next
    end
    shortest cards, tmp
  end
  cards.unshift card
end

shortest cards, Set.new
p @answer