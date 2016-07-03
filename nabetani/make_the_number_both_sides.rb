input = STDIN.gets.chomp.split(",")
num_of_cards = input[0].to_i
target = input[1].to_i
cards = input[2].split("/").map{|pair| pair.each_char.to_a.map{|num| num.to_i}}

# p "#{num_of_cards}, #{target}, #{cards}"

if cards.select{|v| v[0] != 0 || v[1] != 0}.length == 0
  puts "-"
else
  perm = cards.permutation(num_of_cards)
  len = target.to_s.length > num_of_cards ? target.to_s.length : num_of_cards
  tmp_num_abs_min = ("9"*len).to_i

  # たたみ込みで、不完全な解を一時ハッシュに溜め込む
  # To Fix: たたみ込みで、不完全な解を一時ハッシュに溜め込むってアルゴリズムとしてどうなの
  abs = perm.inject({}) do |h, num|
    flg = false
    tmp_num, tmp_num_abs = 0, target
    table, back = 0, 0
    table_abs, back_abs = target, target

    num_of_cards.times do |i_card|
      # カードごとにどちら側の数字を使うかを上位桁から判定
      # To Fix: 下記のケースが作れるカードの組の場合、解けない
      # target = 2345, table = 3346, back = 1344

      side = -1
      digit = 10 ** (num_of_cards - 1 - i_card)
      # 途中結果の誤差の絶対値が最小となるよう調整
      # target = 2282, num[i_card] = 1/3の場合、この調整がないと
      # target - 1000 = 1282, target - 3000 = 718
      # となり解が 1283とかだった場合に求められない
      adjust = target % digit
      # p "#{digit}, #{num[i_card]}"
      # sleep 1
      
      if num[i_card][0] == 0 && num_of_cards > 1 && i_card == 0
        side = 1
        back = num[i_card][side] * digit + adjust
        back_abs = (target - back).abs
      elsif num[i_card][1] == 0 && num_of_cards > 1 && i_card == 0
        side = 0
        table = num[i_card][side] * digit + adjust
        table_abs = (target - table).abs
      else
        tmp = (0..1).map{|i| num[i_card][i] * digit + adjust}
        table, back = tmp_num + tmp[0], tmp_num + tmp[1]
        
        table_abs, back_abs = (target - table).abs, (target - back).abs
        side = table_abs < back_abs ? 0 : 1
      end

      tmp_num = (side == 0) ? table - adjust : back - adjust
      tmp_num_abs = (side == 0) ? table_abs + adjust : back_abs + adjust
      # p "#{tmp_num}, #{tmp_num_abs}, #{i_card}, #{table}, #{back}"
      # sleep 1

      if tmp_num_abs > tmp_num_abs_min
        # p "#{tmp_num_abs}, #{tmp_num_abs_min}"
        flg = true
        break
      end
    end
    next h if flg

    num_abs_min = tmp_num
    h[tmp_num] = tmp_num_abs
    h
  end
  # p abs.values.min

  min = abs.values.min
  puts abs.select{|key, value| key if value == min}.keys.sort.join(",")
end