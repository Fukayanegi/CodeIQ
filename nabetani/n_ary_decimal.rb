input_strs = []
while line = STDIN.gets
  input_strs << line.chomp.split("\t")
end

def split_nrd num
  tmp = ("%.9f" % num).split(".")
  [tmp[0].to_i, tmp[1].reverse]
end

def plus_nrd num1, num2

  num1_n, num1_str = split_nrd num1
  num2_n, num2_str = split_nrd num2
  answer = []

  # 小数部の計算
  rise = 0
  (0..8).each do |idx|
    p "#{idx}, #{num1_str[idx]}, #{num1_str}"
    p "#{idx}, #{num2_str[idx]}, #{num2_str}"
  end

  # 整数部の計算
  p num1_n + num2_n + rise
end

input_strs.each do |line_no, exp, answer|
  plus_nrd *(exp.split("+").map{|v| v.to_f})
end