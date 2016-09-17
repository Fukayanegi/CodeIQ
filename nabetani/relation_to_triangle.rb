require 'scanf'

relations = STDIN.gets.chomp.split(" ").map do |relation|
  pos = relation.scanf "(%d,%d)(%d,%d)(%d,%d)/(%d,%d)"
  triangle = [[pos[0], pos[1]], [pos[2], pos[3]], [pos[4], pos[5]]]
  point = [pos[6], pos[7]]
  [triangle.sort_by!{|vertex| vertex[0]}, point]
end

def judge_relation triangle, point
  answer = "-"
  if triangle.include? point
    # 頂点
    answer = "C"
  else
    if (point[0] < triangle.map{|vertex| vertex[0]}.min ||
      point[0] > triangle.map{|vertex| vertex[0]}.max ||
      point[1] < triangle.map{|vertex| vertex[1]}.min ||
      point[1] > triangle.map{|vertex| vertex[1]}.max)
      # 文句なしの外側
      answer = "D"
    else
      target_lines = point[0] >= triangle[0][0] && point[0] <= triangle[1][0] ? [[0,1], [0,2]] : [[1, 2], [0, 2]]
      # 頂点を結ぶ線分の傾き、切片
      lines = target_lines.map do |(p1_idx, p2_idx)|
        p1, p2 = triangle[p1_idx], triangle[p2_idx]
        a, b = 0, 0
        if p1[0] == p2[0]
          a = Rational(point[1], p1[0])
          b = 0
        elsif p1[1] == p2[1]
          b = p1[1]
        else
          a = Rational(p2[1] - p1[1], (p2[0] - p1[0]))
          b = p1[1] - a * p1[0]
        end
        [a, b]
      end

      y1 = lines[0][0] * point[0] + lines[0][1]
      y2 = lines[1][0] * point[0] + lines[1][1]
      y1, y2 = y2, y1 if y1 > y2
      if point[1] == y1 || point[1] == y2
        # いずれかの線分上
        answer = "B"
      elsif point[1] > y1 && point[1] < y2
        # 線分の間にpointがある
        answer = "A"
      end
    end
  end
  answer
end

answer = ""
relations.each do |(triangle, point)|
  answer << judge_relation(triangle, point)
end
puts answer