n = STDIN.gets.chomp.to_i

answer = 0
1.upto(n) do |start_r|
  start_r.upto(n) do |start_c|
    # 1行目の数値
    width = 1
    base_width = 0
    base_width_next = start_r * start_c + start_r * (width - 1)
    while base_width_next <= n
      base_width = base_width_next
      width += 1
      base_width_next += start_r * start_c + start_r * (width - 1)

      height = 1
      sum = 0
      base = base_width / start_r
      sum_next = base_width + base * (height - 1)
      while sum_next <= n && height <= start_c + width - 1
        sum = sum_next
        height += 1
        sum_next += base_width + base * (height - 1)
      end
      height -= 1

      # p "start_r = #{start_r}, start_c = #{start_c}, width = #{width - 1}, base_width = #{base_width}" if sum == n
      # p "height = #{height}, sum = #{sum}" if sum == n
      # p "single" if sum == n && start_r == start_c && width - 1 == height
      answer += 1 if sum == n
      answer += 1 if sum == n && (start_r != start_c || width - 1 != height)
    end
  end
end

puts answer