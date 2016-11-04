# コマンドライン引数に"-dlog"があった場合にログを出力する関数
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Solver
  DIRECTION = {:UP => [0, 1], :RIGHT => [1, 0], :DOWN => [0, -1], :LEFT => [-1, 0]}

  Coordinate = Struct.new(:x, :y) {
    def + other
      Coordinate.new(self.x + other.x, self.y + other.y)
    end
    def * steps
      Coordinate.new(self.x * steps, self.y * steps)
    end
  }

  attr_accessor :i_patterns

  def initialize i_blocks, a_blocks
    @i_patterns = []
    (1..i_blocks - 1).to_a.combination(a_blocks - 2).each do |positions|
      i_blocks_num = []
      last_but_one = positions.inject(0) do |prev, pos|
        i_blocks_num << (pos - prev)
        pos
      end
      i_blocks_num << (i_blocks - last_but_one)

      i_patterns << i_blocks_num if i_blocks_num.all?{|v| v.odd?}
    end
    dlog({:i_patterns => i_patterns})
  end

  def progress pattern, directions, passed, passed_directions
    if pattern.length == 0
      turn_count = passed_directions.inject(Hash.new(0)){|acc, (direction, tiles)| acc[direction] = (acc[direction] ||= 0) + 1; acc}
      passed_tiles = passed_directions.inject([]){|acc, (direction, tiles)| acc << tiles; acc}
      has_mirror = 2
      dlog({:passed_tiles => passed_tiles})
      if passed_tiles == passed_tiles.reverse
        dlog({:turn_count => turn_count})
        horizonal = turn_count[:RIGHT] - turn_count[:LEFT]
        vertical = turn_count[:UP] - turn_count[:DOWN]
        has_mirror = 1 if (horizonal == 0 && vertical.odd?) || (vertical == 0 && horizonal.odd?)
      end
      return 4 * has_mirror
    end

    steps = pattern.shift
    answer = 0
    directions.each do |direction|
      next_pos = passed[-1] + (Coordinate.new(*DIRECTION[direction]) * steps)
      passed << next_pos
      passed_directions << [direction, steps]
      answer += progress(pattern, DIRECTION.keys - directions, passed, passed_directions)
      passed_directions.pop
      passed.pop
    end
    pattern.unshift steps
    answer
  end

  def solve
    answer = 0
    i_patterns.each do |pattern|
      i_positions = [Coordinate.new(0, 0)]
      passed_directions = []
      [:UP, :RIGHT].each do |direction|
        break if pattern.length == 0
        steps = pattern.shift
        next_pos = i_positions[-1] + (Coordinate.new(*DIRECTION[direction]) * steps)
        passed_directions << [direction, steps]
        i_positions << next_pos
      end

      if pattern.length == 0
        # 回転 * 鏡
        answer += 4 * 2
      else
        answer += progress(pattern, [:UP, :DOWN], i_positions, passed_directions)
      end
    end
    answer
  end
end

i_blocks, a_blocks = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
dlog({:i_blocks => i_blocks, :a_blocks => a_blocks})

solver = Solver.new(i_blocks, a_blocks)
p solver.solve