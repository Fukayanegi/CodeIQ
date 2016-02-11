max_side_length, TARGET_SQUARES = STDIN.gets.chomp!.split(',').map{|val| val.to_i}

@memo = Hash.new

# 再帰呼び出しの度にnum_of_squaresをデクリメントしていき、
# width == height、またはnum_of_square == 1のときの状態で、切り取れる正方形の数を返す
# width != height、かつnum_of_suquares == 1の場合、TARGET_SQUARES+1を返すことで呼び出し元で条件に合わない形とさせる
def cut_squares width, height, num_of_squares
  width, height = height, width if height > width
  key = "#{width}:#{height}"
  @memo[key] if @memo.include? key

  return 1 if width == height
  return TARGET_SQUARES + 1 if num_of_squares == 1

  @memo[key] = (cut_squares width - height, height, num_of_squares - 1) + 1
  @memo[key]
end

# 最初の幅、高さが決まれば後は決まった処理の繰り返し
# 幅の範囲：round(最大幅/2)..最大幅
# 高さの範囲：1..(幅-1)

# max_side_length=7の場合、width = [7,6,5,4]
width = Array.new((max_side_length.to_f / 2).round) {|i| max_side_length - i }

answer = 0
width.each do |w|
  (1..(w - 1)).each do |h|
    answer += 1 if (cut_squares w, h, TARGET_SQUARES) == TARGET_SQUARES
  end
end

p answer