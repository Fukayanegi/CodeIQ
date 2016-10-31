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
      i.upto(h-1) do |l|
        solid[l][idx[0]][j] = 1
      end
    end
  end
end
dlog({:solid => solid})

def under_patterns solid, target, selected, z_idx, y_idx
  under_mask = selected.inject(0){|acc, v| acc += (1 << (2 - v))}
  selected_target = (0..target.length-1).to_a.map{|v| (selected.include?(v) || target[v] == 1) ? 1 : 0}
  # dlog({:selected_target => selected_target})
  patterns = zy_patterns(solid, under_mask, z_idx + 1, y_idx)
  patterns.each do |pattern|
    pattern.unshift selected_target
  end
  patterns
end

def zy_patterns solid, above_mask, z_idx, y_idx
  return [[]] if z_idx == solid.length
  target = solid[z_idx][y_idx].map.with_index{|v, i| (above_mask[2 - i]) == 1 ? 1 : v}
  idxes = target.map.with_index{|v, i| i if v.nil?}.select{|v| !v.nil?}

  under_patterns_all = []

  less = target.select{|v| v == 1}.length > 0 ? 0 : 1
  less.upto(idxes.length) do |choices|
    idxes.combination(choices).each do |blocks|
      under_patterns_all.concat(under_patterns(solid, target, blocks, z_idx, y_idx))
    end
  end

  under_patterns_all
end

patterns = []
d.times do |y|
  patterns << zy_patterns(solid, 0, 0, y)
end

candidates = [0]
patterns.each do |pattern|
  tmp = []
  pattern.each do |zx|
    candidates.each do |candidate|
      tmp << (candidate | zx.join.to_i(2))
    end
  end
  candidates = tmp
end

puts candidates.count{|v| v == projection[:FRONT].join.to_i(2)}