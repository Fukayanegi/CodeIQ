def insert_array ary, new_value
  # FIXME: 探索アルゴリズムを二分探索に
  ary.each_with_index do |value, index|
    if new_value <= value
      ary.insert(index, new_value)
      break
    end
  end
  # p ary
end

def insert_array_rev ary, new_value
  # FIXME: 探索アルゴリズムを二分探索に
  ary.reverse.each_with_index do |value, index|
    if new_value >= value
      ary.insert(ary.length - index, new_value)
      break
    end
  end
  # p ary
end

numbers = [STDIN.gets.chomp!.to_i]
median_pos = 0
p numbers[median_pos]

while (line = STDIN.gets) do
  number = line.chomp!.to_i

  if number <= numbers[median_pos]
    insert_array numbers, number
  else
    insert_array_rev numbers, number
  end

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