max_side_length, num_of_square = STDIN.gets.chomp!.split(',').map{|val| val.to_i}

@memo = Hash.new

# num_of_square == 0 && width == height == 1がpatternの一つ
# 引数で与えられたnum_of_suquareまでカウントしたら打ち切る
def count_patterns width, height, num_of_square
  return 1 if num_of_square == 1 && width == 1 && height == 1
  return 0 if width == height || num_of_square == 1

  width, height = height, width if height > width

  count_patterns width-height, height, num_of_square-1
end

# 最初の幅、高さが決まれば後は決まった処理の繰り返し
# 幅の範囲：round(最大幅/2)..最大幅
# 高さの範囲：1..(幅-1)

# max_side_length=7の場合、width = [7,6,5,4]
width = Array.new((max_side_length.to_f/2).round) {|i| max_side_length - i }

answer = 0
width.each do |w|
  (1..w-1).each do |h|
    answer += count_patterns w, h, num_of_square
  end
end

p answer