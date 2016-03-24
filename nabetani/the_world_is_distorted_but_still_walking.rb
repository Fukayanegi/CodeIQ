DIRECTION = [[1,0],[0,1],[-1,0],[0,-1]]

def display world
  world.each do |row|
    p row.map {|col| col.value}
  end
end

class CellValue
  attr_accessor :value
  def initialize
    @value = "*"
    @x = 0
    @y = 0
  end
end

@world = Array.new(10){Array.new(10){CellValue.new}}
values1 = ("0".."9").to_a
values1.concat ("a".."k").to_a
values1.each_with_index do |value, i|
  row = i % 3
  col = i / 3
  @world[row][col].value = value
end
values2 = ("l".."z").to_a
values2.concat ("A".."F").to_a
values2.each_with_index do |value, i|
  row = i / 3
  col = 9 - i % 3
  @world[row][col].value = value
end
values3 = ("G".."Z").to_a
values3.concat ["@"]
values3.each_with_index do |value, i|
  row = 9 - i / 3
  col = i % 3
  @world[row][col].value = value
end

display @world