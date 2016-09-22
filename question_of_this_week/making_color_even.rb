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

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
# p "#{m}, #{n}"

target_map = create_target_map m, n
mask = ~target_map & ("1"*(m+2)*(n+2)).to_i(2)
# show_map target_map, m + 2, n + 2
# show_map mask, m + 2, n + 2

@memo = Set.new
@memo << (target_map & mask)
@memo << mask
next_maps = [target_map & mask]
steps = 0

while next_maps.length > 0
  target_maps = next_maps
  next_maps = []
  continue = false
  1.upto(m) do |row|  
    1.upto(n) do |col|
      cross = cross_bit m + 2, n + 2, row, col
      target_maps.each do |next_map|
        tmp = ((next_map ^ cross) & mask)
        if !@memo.include? tmp
          tmp_rev = ~tmp & ("1"*(m+2)*(n+2)).to_i(2)
          next_maps << tmp
          # next_maps << (tmp_rev & mask)
          @memo << tmp
          @memo << (tmp_rev & mask)
        end
      end
    end
  end
  steps += 1 if next_maps.length > 0
  # p "#{steps} #{next_maps.length}"
end

puts steps
# @memo.each do |map|
#   p "*" * 20
#   show_map(map, m + 2, n + 2)
# end