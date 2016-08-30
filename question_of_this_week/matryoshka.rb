max_size = STDIN.gets.chomp.to_i
# p "max_size = #{max_size}"

# 外側の人形を最大サイズから何個置けばよいか
# 最大サイズから間隔が空くと同じ外側の人形の数の場合パターン数が減るだけ
# ex)8,7,6,5,4,3,2,1で3つを外側の人形とすると
# 8,7,6 => 3**5
# 8,7,3 => 3**2*2**3

answer = 0
(1..max_size).each do |out_doll|
  tmp = out_doll**(max_size - out_doll)
  # p "tmp = #{tmp}"
  break if tmp < answer
  answer = tmp
end

puts answer