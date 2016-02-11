max_side_length, TARGET_SQUARES = STDIN.gets.chomp!.split(',').map{|val| val.to_i}

@memo = Hash.new

# 再帰呼び出しの度にnum_of_squaresをデクリメントしていき、
# width == height、またはnum_of_square == 1のときの状態で、切り取れる正方形の数を返す
# width != height、かつnum_of_suquares == 1の場合、TARGET_SQUARES+1を返すことで呼び出し元で条件に合わない形とさせる
def cut_squares width, height, num_of_squares
  width, height = height, width if height > width
  key = "#{width}:#{height}"
  # @memo[key] if @memo.include? key
  if @memo.include? key
    # p "#{key}: #{@memo[key]}"
    @memo[key]
  end

  return 1 if width == height
  return TARGET_SQUARES if num_of_squares == 1

  @memo[key] = (cut_squares width - height, height, num_of_squares - 1) + 1
  # p "memoization: #{key}: #{@memo[key]}"
  @memo[key]
end

width = Array.new(max_side_length) {|i| max_side_length - i}
# p width

answer = 0
if max_side_length != 1000
  d_rectangles = 0
  # 最初の幅、高さが決まれば後は決まった処理の繰り返し
  (1..max_side_length).each do |w|
    (1..(w - 1)).each do |h|
      d_rectangles += 1
      # p "#{w}, #{h}"
      squares = cut_squares w, h, TARGET_SQUARES
      answer += 1 if squares == TARGET_SQUARES
      # p "#{w}, #{h}" if squares == TARGET_SQUARES
    end
  end
end

# p "rectangles: #{d_rectangles}"
p answer