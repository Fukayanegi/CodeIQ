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
  answer_decimal = []

  # 小数部の計算
  rise = 0
  (0..8).each do |idx|
    tmp = num1_str[idx].to_i + num2_str[idx].to_i + rise
    rise = tmp / (2 + idx)
    remainder = tmp % (2 + idx)
    answer_decimal.unshift remainder
  end

  # 整数部の計算に小数部を結合
  ((num1_n + num2_n + rise).to_s + "." + answer_decimal.join).to_f
end

wrong_line = []
input_strs.each do |line_no, exp, answer_input|
  answer = plus_nrd *(exp.split("+").map{|v| v.to_f})
  if answer != answer_input.to_f
    # デバッグ用
    # p "#{line_no}, #{exp}, #{answer_input} : #{answer}"
    wrong_line << line_no
  end
end

puts wrong_line.join(",")