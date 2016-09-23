require 'set'

def create_target_map m, n
  bit_str = "1" * (n + 2)
  m.times{bit_str << ("1" + "0" * n + "1")}
  bit_str << "1" * (n + 2)
  bit_str.to_i(2)
end

def show_map map_bit, m, n
  ("%0#{m*n}b" % map_bit).scan(/.{1,#{n}}/).each{|row| p row}
end

def cross_bit rows, cols, y, x
  base = 7 << ((rows - y - 1) * cols + (cols - x - 2))
  upper = 2 << ((rows - y - 1) * cols + (cols - x - 2) + cols)
  lower = 2 << ((rows - y - 1) * cols + (cols - x - 2) - cols)
  (base | upper | lower)
end

def up_side_down map_bit, m, n, masks
  up_side_down = 0
  masks.each_with_index do |usdm, row|
    up_side_down |= ((map_bit & usdm) << ((m - 2 * row - 1) * n))
  end
  up_side_down
end

def mirror map_bit, m, n, masks
  mirror = 0
  masks.each_with_index do |mm, col|
    mirror |= ((map_bit & mm) >> (n - 2 * col - 1))
  end
  mirror
end

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
# p "#{m}, #{n}"

target_map = create_target_map m, n
mask = ("1"*(m+2)*(n+2)).to_i(2)
map_mask = ~target_map & mask
up_side_down_mask = []
(m+2).times do |row|
  up_side_down_mask << (("1"*(n+2)).to_i(2) << row * (n+2))
end
mirror_mask = []
(n+2).times do |col|
  mirror_mask << ((("1"+"0"*(n+1))*(m+2)).to_i(2) >> col)
end
# show_map target_map, m + 2, n + 2
# show_map map_mask, m + 2, n + 2

@cross = Array.new(m) do |row|
  Array.new(n) do |col|
    cross_bit(m + 2, n + 2, row + 1, col + 1)
  end
end

@memo = Set.new
@memo << (target_map & map_mask)
@memo << map_mask
next_maps = [target_map & map_mask]
steps = 0

while next_maps.length > 0
  target_maps = next_maps
  next_maps = []

  1.upto(m) do |row|  
    1.upto(n) do |col|
      cross = @cross[row-1][col-1]
      target_maps.each do |next_map|
        tmp = ((next_map ^ cross) & map_mask)
        # tmp_mirror = mirror tmp, m + 2, n + 2, mirror_mask
        # tmp_mirror_rev = ((~tmp_mirror & mask) & map_mask)
        if !(@memo.include? tmp) #&& !(@memo.include? tmp_rev) \
        #   && !(@memo.include? tmp_usd) && !(@memo.include? tmp_usd_rev) \
        #   && !(@memo.include? tmp_mirror) && !(@memo.include? tmp_mirror_rev)
          tmp_rev = ((~tmp & mask) & map_mask)
          tmp_usd = up_side_down tmp, m + 2, n + 2, up_side_down_mask
          tmp_usd_rev = ((~tmp_usd & mask) & map_mask)
          @memo << tmp
          @memo << tmp_rev
          @memo << tmp_usd
          @memo << tmp_usd_rev
          # @memo << tmp_mirror
          # @memo << tmp_mirror_rev
          next_maps << tmp
        end
      end
    end
  end
  steps += 1 if next_maps.length > 0
  # p "#{steps} #{next_maps.length}"
end

puts steps
