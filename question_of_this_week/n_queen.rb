require 'set'

@n = STDIN.gets.chomp.to_i

map_nq = Set.new

def show_map n, width
  map = "%0#{@n**2}b" % n
  while map.length > 0
    p map.slice! 0, width
  end
end

def block n, pos
  r = (pos / @n - @n + 1).abs
  c = (pos % @n - @n + 1).abs

  # 縦
  (0..(@n-1)).each do |row|
    n |= 1 << (@n**2-1) - row * @n - c
  end

  # 横
  (0..(@n-1)).each do |col|
    n |= 1 << (@n**2-1) - r * @n - col
  end

  # 斜め
  (0..(@n-1)).each do |row|
    left = (@n**2-1) - row * @n - c + (r - row).abs
    right = (@n**2-1) - row * @n - c - (r - row).abs

    n |= 1 << left if (left % @n - @n + 1).abs < c
    n |= 1 << right if (right % @n - @n + 1).abs > c
  end

  n
end

def nq n, mask, map, queens
  ret = Set.new

  if queens == 0
    ret << map
    return ret
  end

  n.downto(0) do |digit|
    mask_next = mask
    map_next = map
    if (1 << digit) & mask == 0
      map_next |= 1 << digit
      mask_next |= 1 << digit
      mask_next = (block mask_next, digit)
      # show_map mask_next, @n
      # p "*"*20
      # show_map map_next, @n
      # p "*"*20
      ret.merge(nq n, mask_next, map_next, queens-1)
    end
    mask |= 1 << digit
  end
  return ret
end

answer = nq @n**2-1, 0, 0, @n
answer.each do |map|
  show_map map, @n
  p "*"*20
end
p answer.length