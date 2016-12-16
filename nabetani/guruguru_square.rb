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
  DIRECTION = [:left, :down, :right, :up]

  attr_reader :center
  def initialize center
    @center = center
  end

  def solve
    return [2, 4, 6, 8] if center == 1
    # 1 + 2 * 4 + 4 * 4 + 6 * 4
    # 1 + 2 * (n - 1) * 4
    periphery = 1
    num = 1
    while true do
      num += 2 * (periphery - 1) * 4
      break if num >= center
      periphery += 1
    end

    right_above = num - 2 * (periphery - 1) * 4
    right_above_pre = ((Math.sqrt(right_above) - 2) ** 2).to_i
    right_above_next = ((Math.sqrt(right_above) + 2) ** 2).to_i
    rest = center - right_above
    side = 2 * (periphery - 1)
    direction = (rest - 1) / side
    dlog({:periphery => periphery, :num => num, :right_above => right_above, :rest => rest, :side => side})
    dlog({:direction => Solver::DIRECTION[direction]})

    answer = [center - 1, center + 1]
    answer << center + right_above_next - right_above + 2 * direction + 1
    rest_index = rest % side
    if center == right_above + 1
      answer << center + right_above_next - right_above + 2 * direction - 1
    elsif rest_index == 0 && center != num
      answer << center + right_above_next - right_above + 2 * (direction + 1) + 1
    else
      answer << center - (right_above - right_above_pre + 2 * direction + 1)
    end
    answer
  end
end

center = STDIN.gets.chomp.to_i
# center = 31
dlog({:center => center})
solver = Solver.new(center)
puts solver.solve.sort.join(",")