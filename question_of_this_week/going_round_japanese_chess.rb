STEPS = [0, 1, 5, 10, 20, nil]
n = STDIN.gets.chomp.to_i

def calc_steps patterns, n, flg
  answer = patterns.repeated_combination(n).map do |comb|
    v = 0
    if !(comb.include? nil)
      v = comb.inject(:+)
      v = 8 if (v == 0 && flg)
    end
    v
  end
  answer.sort!.uniq!
  answer
end

# 1回振ったときの進む数のパターン
patterns = calc_steps STEPS, 4, true
# p patterns
# p patterns.length

# 角からはみ出す数ごとのパターン数
patterns_by_out_steps = patterns.inject({}) do |acc, v|
  key = v % 8
  (acc.include? key) ? (acc[key] += 1) : (acc[key] = 1)
  acc
end
# p patterns_by_out_steps

# target_comb = n回振ってはみ出す数の和が8で割り切れる数になる組み合わせ
# ここで順列を求めると計算時間が膨大になってしまう
target_comb = (0..7).to_a.repeated_combination(n).select{|comb| comb.inject(:+) % 8 == 0}
# p target_comb

# target毎に各はみ出す数のパターン数を乗算したものの和が答え
answer = target_comb.inject(0) do |acc, comb|
  # 組み合わせのパターンから順列を計算
  factor = (1..n).to_a.inject(:*)
  comb.inject({}){|acc, v| (acc.include? v) ? (acc[v] += 1) : (acc[v] = 1); acc}.each do |k, v|
    factor /= (1..v).to_a.inject(:*)
  end
  tmp = comb.inject(1) do |acc_inner, v|
    acc_inner *= patterns_by_out_steps[v]
  end

  acc += tmp * factor
end
p answer