max_side_length, TARGET_SQUARES = STDIN.gets.chomp!.split(',').map{|val| val.to_i}

@memo = Hash.new

def count_patterns2 max_side_length
  answer = 0
  (1..max_side_length).each do |w|
    (1..(w - 1)).each do |h|
      # p "#{w}, #{h}"
      squares = 0
      tmp_w, tmp_h = w, h
      while tmp_h != 0 do
        squares += tmp_w / tmp_h
        tmp_w, tmp_h = tmp_h, tmp_w - tmp_h * (tmp_w / tmp_h)
      end
      answer += 1 if squares == TARGET_SQUARES
    end
  end
  answer
end

p count_patterns2 max_side_length