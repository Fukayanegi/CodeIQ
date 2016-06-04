require 'set'

@n = STDIN.gets.chomp.to_i

map_nq = Set.new

def show_map n, width
  map = "%0#{@n**2}b" % n
  while map.length > 0
    p map.slice! 0, width
  end
end

# posを起点にクイーンの進む方向にビットマップnをブロックする関数
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

# nクイーンの解を求める
# [0,0]から[n,n]まで置ける位置にクイーンを再帰的に配置する関数
def solve digits, mask, map, queens
  ret = Set.new

  if queens == 0
    ret << map
    return ret
  end

  digits.downto(0) do |digit|
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
      ret.merge(solve digits, mask_next, map_next, queens-1)
    end
    mask |= 1 << digit
  end
  return ret
end

maps = solve @n**2-1, 0, 0, @n
# maps.each do |map|
#   show_map map, @n
#   p "*"*20
# end
maps_h = maps.inject(Hash.new) do |h, map|
  key = ("%0#{@n**2}b" % map)[0..@n-1]
  h[key] = [] if !h.include? key
  tmp = h[key]
  tmp << map
  h
end
# p maps_h

answer = 0
full = ("1"*@n**2).to_i(2)

# maps.to_a.each {|map| p "%0#{@n**2}b" % map}

def fill? map, hash
  return true if hash.length == 0
  k, ary = hash.shift
  # ary.each{|v| p "%0#{@n**2}b" % v}
  ary.each do |a|
    map_next = map
    return true if fill?(map_next^a, hash) if (map_next &= a) == 0
  end
  false
end

# 探索
# n*nの盤面にn個のqueenを置いているため、n面以上重ねないと全てが埋まらない
@n.upto(maps.length).each do |num|

  if num == @n
    # num == @n の場合は高速化可能
    answer = @n if fill?(0, maps_h)
  else
    # num != @n の場合の高速化は課題
    maps.to_a.combination(num).each do |comb|
      layered = comb.inject(0) {|acm, map| acm ^ map}
      if layered == full
        answer = num
        break
      end
    end
  end

  break if answer > 0
end

puts answer
