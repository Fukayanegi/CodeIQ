def dlog variables, method = ""
  # TODO: 何かもっとエレガントな方法で
  if ARGV[0] == "-debug"
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

projection = {}
[:ABOVE, :SIDE, :FRONT].each do |pos|
  projection[pos] = STDIN.gets.scan(/(\[([10,]*)\])/).map{|m| m[1].split(",").map{|v| v.to_i}}
end
# while line = STDIN.gets
# end
projection.each{|plane| dlog({:plane => plane})}

# 配置できない場所を0、不定をnil
h, d, w = 3, 3, 3
solid = Array.new(h) do |z|
  Array.new(d) do |y| 
    Array.new(w) do |x|
      (projection[:ABOVE][y][x] & projection[:SIDE][z][d-1-y] & projection[:FRONT][z][x]).zero? ? 0 : nil
    end
  end
end

# 上面図から判断して必ず配置される場所を1に
solid[h-1].each_with_index do |row, i|
  row.each_with_index do |block, j|
    solid[h-1][i][j] = block || projection[:ABOVE][i][j]
  end
end

# 側面図から判断して必ず配置される場所を1に
projection[:SIDE].each_with_index do |plane, i|
  plane.each_with_index do |row, j|
    idx = []
    solid[i][d-1-j].each_with_index{|block, k| idx << k if block.nil? || block.nonzero?}
    if row == 1 && idx.length == 1
      dlog({:side => "#{i}, #{j}"})
      dlog({:solid => idx[0]})
      i.upto(h-1) do |l|
        solid[l][d-1-j][idx[0]] = 1
      end
    end
  end
end

# 正面図から判断して必ず配置される場所を1に
projection[:FRONT].each_with_index do |plane, i|
  plane.each_with_index do |col, j|
    idx = []
    solid[i].map{|row| row[j]}.each_with_index{|block, k| idx << k if block.nil? || block.nonzero?}
    if col == 1 && idx.length == 1
      dlog({:front => "#{i}, #{j}"})
      dlog({:solid => idx[0]})
      i.upto(h-1) do |l|
        solid[l][idx[0]][j] = 1
      end
    end
  end
end

dlog({:solid => solid})

# nilの場所
idx = []
solid.each_with_index do |plane, z|
  plane.each_with_index do |row, y|
    row.each_with_index do |block, x|
      idx << [z, y, x] if block.nil?
    end
  end
end

dlog({:idx => idx})

answer = 0
0.upto(idx.length) do |choices|
  dlog({:choices => choices})
  idx.combination(choices).each do |patterns|
    dlog({:patterns => patterns})
    patterns.each do |(z, y, x)|
      solid[z][y][x] = 1
    end
    dlog({:solid => solid})

    side = true
    projection[:SIDE].each_with_index do |plane, i|
      plane.each_with_index do |row, j|
        placed = []
        solid[i][d-1-j].each_with_index{|block, k| placed << k if block == 1}
        dlog({:row => row, :placed => placed})
        if (row == 0 && placed.length > 0) || (row == 1 && placed.length == 0)
          side = false
        end
        break if !side
      end
      break if !side
    end

    if side
      front = true
      projection[:FRONT].each_with_index do |plane, i|
        plane.each_with_index do |col, j|
          placed = []
          solid[i].map{|row| row[j]}.each_with_index{|block, k| placed << k if block == 1}
          dlog({:col => col, :placed => placed})
          if (col == 0 && placed.length > 0) || (col == 1 && placed.length == 0)
            front = false
          end
          break if !front
        end
        break if !front
      end
      answer += 1 if front
    end

    patterns.each do |(z, y, x)|
      solid[z][y][x] = 0
    end
  end
end

puts answer