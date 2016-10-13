Point = Struct.new("Point", :x, :y)

class Triangle
  attr_accessor :vertexes, :line_segments
  def initialize vertexes
    @vertexes = vertexes
    @line_segments = vertexes.combination(2).map{|p1, p2| LineSegment.new(p1, p2)}
  end

  def inside? point
    above, beneath, left, right = false, false, false, false
    line_segments.each do |line_seg|
      # p point
      # p line_seg
      if tmp_y = line_seg.y(point.x)
        above = true if tmp_y > point.y
        beneath = true if tmp_y < point.y
      end
      if tmp_x = line_seg.x(point.y)
        left = true if tmp_x < point.x
        right = true if tmp_x > point.x
      end
    end

    above && beneath && left && right
  end

  def num_of_inner_vertexes another_triangle
    answer = another_triangle.vertexes.map do |vertex|
      inside?(vertex) ? 1 : 0
    end
    answer.reduce(:+)
  end

  def num_of_common_vertexes another_triangle
    answer = vertexes.map do |vertex|
      another_triangle.vertexes.include?(vertex) ? 1 : 0
    end
    answer.reduce(:+)
  end

  def num_of_intersections another_triangle
    answer = another_triangle.line_segments.map do |another_line_seg|
      num_of_intersections_with_line(another_line_seg)
    end
    answer.reduce(:+)
  end

  def num_of_intersections_with_line another_line_seg
    answer = line_segments.map do |line_seg| 
      line_seg.has_point_of_intersection?(another_line_seg) ? 1 : 0
    end
    answer.reduce(:+)
  end
end

class LineSegment
  attr_accessor :a, :b, :c, :p1, :p2
  def initialize p1, p2
    @p1, @p2 = (p1.x < p2.x ? [p1, p2] : [p2, p1])
    if @p1.x == @p2.x
      @a = 0
      @b = 1
      @c = -1 * @p1.x
    else
      @b = Rational((@p2.y - @p1.y), (@p2.x - @p1.x))
      @c = @p1.y - @b * @p1.x

      @a = @b.denominator
      @c = @c * @b.denominator
      @b = @b.numerator
    end
  end

  def inclination
    return nil if a == 0
    Rational(b, a)
  end

  def intercept
    return nil if a == 0
    Rational(c, a)
  end

  def inclination_x
    return nil if b == 0
    Rational(a, b)
  end

  def intercept_x
    return nil if b == 0
    -1 * Rational(c, b)
  end

  def x_on_the_line? x
    x >= p1.x && x <= p2.x
  end

  def on_the_line? point
    if p1.x == p2.x
      y1, y2 = p1.y < p2.y ? [p1.y, p2.y] : [p2.y, p1.y]
      point.y >= y1 && point.y <= y2
    else
      x_on_the_line?(point.x)
    end
  end

  def y x
    return nil if a == 0
    # p "p1x: #{p1.x}, p2x: #{p2.x}, x: #{x}"
    return nil if !x_on_the_line?(x)
    return inclination * x + intercept
  end

  def x y
    return nil if b == 0
    tmp = Rational(a * y - c,  b)
    # p "p1x: #{p1.x}, p2x: #{p2.x}, x: #{tmp}"
    return nil if !x_on_the_line?(tmp)
    return tmp
  end

  def intersection another_line_seg
    # 交点のX座標
    tmp_x = if a == 0
      intercept_x
    elsif another_line_seg.a == 0
      another_line_seg.intercept_x
    else
      (another_line_seg.intercept - intercept) / (inclination - another_line_seg.inclination)
    end

    # 交点のY座標
    tmp_y = if a == 0
      another_line_seg.inclination * tmp_x + another_line_seg.intercept
    else
      inclination * tmp_x + intercept
    end

    Point.new(tmp_x, tmp_y)
  end

  def has_point_of_intersection? another_line_seg, exclude_poi = true
    # 並行の場合false
    return false if (a == 0 && another_line_seg.a == 0) || (b == 0 && another_line_seg.b == 0) \
      || (inclination == another_line_seg.inclination)

    # 交点が双方の線分上にあればtrue
    point = intersection(another_line_seg)
    answer = on_the_line?(point) && another_line_seg.on_the_line?(point)

    # TODO: フラグによる挙動の違いは避けたいところ
    if exclude_poi
      answer &= !(((point == p1) || (point == p2)) && ((point == another_line_seg.p1) || (point == another_line_seg.p2)))
    end

    answer
  end
end

require 'scanf'
relations = STDIN.gets.chomp.split(" ").map do |relation|
  pos = relation.scanf("(%d,%d)(%d,%d)(%d,%d)/(%d,%d)(%d,%d)(%d,%d)")
  triangle1 = Triangle.new([Point.new(*pos[0..1]), Point.new(*pos[2..3]), Point.new(*pos[4..5])])
  triangle2 = Triangle.new([Point.new(*pos[6..7]), Point.new(*pos[8..9]), Point.new(*pos[10..11])])
  [triangle1, triangle2]
end

answer = []
relations.each do |(triangle1, triangle2)|

  # もう一つの三角形の頂点が自身の中にある数
  inner_vertexes = triangle1.num_of_inner_vertexes(triangle2)
  inner_vertexes += triangle2.num_of_inner_vertexes(triangle1)
  # p "inner_vertexes: #{inner_vertexes}"

  # 共有する頂点の数
  common_vertexes = triangle1.num_of_common_vertexes(triangle2)
  # p "common_vertexes: #{common_vertexes}"

  # もう一つの三角形との交点の数（共有する頂点を除く）
  point_of_intersections = triangle1.num_of_intersections(triangle2)
  # p "point_of_intersections: #{point_of_intersections}"
  answer << inner_vertexes + common_vertexes + point_of_intersections
end

puts answer.map{|v| v < 3 ? "-" : v.to_s}.join