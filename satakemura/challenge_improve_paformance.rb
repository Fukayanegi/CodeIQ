def insert_array ary, new_value
  insert_index = 0
  if ary.length == 1
    # 配列の長さが1の場合は挿入場所は2択
    if new_value > ary[0]
      insert_index = 1
    end
  else
    # 挿入場所を2分探索
    index = ary.length / 2
    delta = index

    while true do 
      delta = delta / 2
      delta = 1 if delta == 0
      if new_value < ary[index]
        index = index - delta
      else
        index = index + delta
      end

      # 挿入場所が見つかったら探索終了（whileの条件にすると直感的でないためこの場で判断）
      # p "#{ary.length}, #{new_value}, #{index}"
      if (new_value >= ary[index - 1] || index == 0) && (index == ary.length || new_value <= ary[index])
        insert_index = index
        break
      end
    end
  end

  ary.insert(insert_index, new_value)
  # p ary
end

numbers = [STDIN.gets.chomp!.to_i]
median_pos = 0
p numbers[median_pos]

while (line = STDIN.gets) do
  number = line.chomp!.to_i

  insert_array numbers, number

  if numbers.length.odd?
    median_pos += 1
  end
  # p median_pos

  if numbers.length.even?
    # p "median: #{(numbers[median_pos] + numbers[median_pos + 1]) / 2}"
    p (numbers[median_pos] + numbers[median_pos + 1]) / 2
  else
    # p "median: #{numbers[median_pos]}"
    p numbers[median_pos]
  end
end