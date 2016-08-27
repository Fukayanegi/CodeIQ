n = STDIN.gets.chomp.to_i

answer = 0
1.upto(Math.sqrt(n).to_i) do |start_r|
  start_r.upto(n / start_r) do |start_c|
    # 1行のみで解はあるか
    b = 2 * start_c - start_r
    s = (-1 * b + Math.sqrt(b ** 2 + 8 * start_r * n)) / (2 * start_r)
    # p "start_r = #{start_r}, start_c = #{start_c}, solution = #{s}"

    width = 1
    base = 0
    base_next = start_r * start_c + start_r * (width - 1)
    while base_next <= n
      base = base_next
      delta = base / start_r
      b_h = 2 * base - delta
      height = (-1 * b_h + Math.sqrt(b_h ** 2 + 8 * delta * n)) / (2 * delta)
      # p "start_r = #{start_r}, start_c = #{start_c}, width = #{width}, solution = #{height}" if height % 1 == 0

      if !(start_r == start_c && height.to_i > width)
        answer += 1 if height % 1 == 0
        answer += 1 if (height % 1 == 0) && !(start_r == start_c && width == height.to_i)
      end

      width += 1
      base_next += start_r * start_c + start_r * (width - 1)
    end
  end
end

puts answer
