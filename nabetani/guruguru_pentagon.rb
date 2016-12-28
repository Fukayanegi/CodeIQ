def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

# 明らかにもっとスマートな方法がある気がする

class Crawler
  attr_accessor :target
  attr_reader :value
  def initialize target
    @target = target
    @value = 0
  end

  def next
    if @value > target - 1
      nil
    else
      @value += 1
      value
    end
  end
end

class Pentagon
  POSITIONS = [:top, :top_right, :right, :bottom_right, :bottom, :bottom_left, :left, :top_left]
  NEXT_POSITIONS = {:top => :top_right, :top_right => :right, :right => :left, :left => :top_left, :top_left => :top}
  PAIR_POSITIONS = {:top => :top_left, :top_right => :top_right, :right => :left, \
    :bottom_right => :bottom_left, :bottom => :bottom, :bottom_left => :bottom_right, :left => :right, :top_left => :top}
  RELATED_POSITIONS = {:top => [[:top_left, :top], [:top_right, :left]], \
    :top_right => [[:top, :right], [:right, :top]], \
    :right => [[:top_right, :top_left], [:bottom_right, :right], [:bottom, :bottom_right], [:bottom_left, :bottom], [:left, :bottom_left]], \
    :bottom_right => [[:right, :left], [:bottom, :right], [:bottom_left, :bottom_right], [:left, :bottom]], \
    :bottom => [[:right, :bottom_left], [:bottom_right, :left], [:bottom_left, :right], [:left, :bottom_right]], \
    :bottom_left => [[:left, :right], [:bottom, :left], [:bottom_right, :bottom_left], [:right, :bottom]], \
    :left => [[:top_left, :top_right], [:bottom_left, :left], [:bottom, :bottom_left], [:bottom_right, :bottom], [:right, :bottom_right]], \
    :top_left => [[:top, :top_left], [:left, :top_right]]}

  # aroundはprotectedが望ましい
  attr_reader :value
  attr_accessor :around
  def initialize 
    @around = {}
  end

  def value= crawler
    @value = crawler.next
    # dlog({:value => value})

    if value
      # 値が確定したタイミングで周囲のタイルを埋める
      POSITIONS.each do |pos|
        if (pos == :bottom_right) && around[:right]
          self.around[pos] = around[pos] || around[:right].around[:right] || Pentagon.new()
        elsif (pos == :bottom_left) && around[:left]
          self.around[pos] = around[pos] || around[:left].around[:left] || Pentagon.new()
        else
          self.around[pos] = around[pos] || Pentagon.new()
        end
        # 中心タイルとの紐づけ
        self.around[pos].around[PAIR_POSITIONS[pos]] = self
      end

      # 周囲のタイル同士を紐づける
      POSITIONS.each do |pos|
        around[pos].update(self, pos)
      end

      next_value(crawler)
    end
  end

  def update pentagon, pos
    RELATED_POSITIONS[pos].each do |r_pos|
      self.around[r_pos[1]] = pentagon.around[r_pos[0]]
      tmp = pentagon.around[r_pos[0]]
      tmp.around[PAIR_POSITIONS[r_pos[1]]] = self
    end
  end

  def next_value crawler
    filled_pos = NEXT_POSITIONS.detect{|pos, next_pos| !around[pos].value.nil?}
    pos = filled_pos.nil? ? :top : NEXT_POSITIONS[filled_pos[0]]
    while !around[pos].value.nil?
      pos = NEXT_POSITIONS[pos]
    end
    around[pos].value = crawler
  end
end

class Solver
  attr_reader :center
  def initialize center
    @center = center
    crawler = Crawler.new(1000)
    @pentagon = Pentagon.new
    @pentagon.value = crawler
  end

  def search center
    next_pentagon = @pentagon
    while next_pentagon.value != center
      next_pentagon = next_pentagon.around.inject(nil) do |acc, (pos, pentagon)|
        (acc.nil? || (acc.value < pentagon.value && pentagon.value <= center)) ? pentagon : acc
      end
    end
    next_pentagon
  end

  def solve
    center_pentagon = search(center)
    center_pentagon.around.select{|k, v| Pentagon::NEXT_POSITIONS.keys.include?(k)}.map{|k, v| v.value}.sort
  end
end

center = STDIN.gets.chomp.to_i
dlog({:center => center})
solver = Solver.new(center)
puts solver.solve.sort.join(",")