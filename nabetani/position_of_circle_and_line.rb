require 'scanf'

postions = STDIN.gets.chomp.split(" ").map{|pair| pair.split("/")}

def judge r, d1, d2, d3
  if d1 <= r && d2 <= r
    return "C" if d1 == r && d2 == r
    return "B" if d1 == r || d2 == r
    return "A"
  end

  # このstepに到達する時点で d1 > r || d2 > r
  if d1 == r || d2 == r 
    #TODO: DとGの判別
    return "D" if d3 == 0
    return "G"
  end

  return "F" if d1 < r || d2 < r 

  # このstepに到達する時点で d1 > r && d2 > r
  return "E" if d3 < r
  return "H" if d3 == r
  return "I"
end

answer = []
postions.each do |pair|
  circle = pair[0].scanf("(%d,%d)%d")
  line = pair[1].scanf("(%d,%d)(%d,%d)")
  distance1 = Math.sqrt((line[0] - circle[0])**2 + (line[1] - circle[1])**2)
  distance2 = Math.sqrt((line[2] - circle[0])**2 + (line[3] - circle[1])**2)

  inclination1, inclination2 = 0, 0
  intercept1, intercept2 = 0, 0

  inclination1 = (line[3] - line[1]) / (line[2] - line[0]).to_f

  if inclination1 != 0 && inclination1 != Float::INFINITY
    intercept1 = line[1] - inclination1 * line[0]
    inclination2 = 1 / inclination1
    intercept2 = circle[1] - inclination2 * circle[0]
    x = (intercept2 - intercept1) / (inclination1 - inclination2)
    y = inclination2 * x + intercept2
    y_tmp = inclination1 * x + intercept1
  else
    if inclination1 == Float::INFINITY
      x = line[0]
      y = circle[1]
      y_tmp = y
    else
      x = circle[0]
      y = line[1]
      y_tmp = y
    end
  end

  distance3 = Math.sqrt((x - circle[0])**2 + (y - circle[1])**2)

  # p "#{inclination1}, #{intercept1}, #{inclination2}, #{intercept2}"
  # p "#{x}, #{y}, #{y_tmp}"
  # p "#{distance1}, #{distance2}, #{distance3}"

  answer << judge(circle[2], distance1, distance2, distance3)
end

puts answer.join