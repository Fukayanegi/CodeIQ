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
patterns_by_out_steps = {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0}
patterns.inject(patterns_by_out_steps) do |acc, v|
  key = v % 8
  acc[key] += 1
  acc
end
# p patterns_by_out_steps

# target = n回振ってはみ出す数の和が8で割り切れる数になる順列
target_comb = (0..7).to_a.repeated_permutation(n).select{|comb| comb.inject(:+) % 8 == 0}
# p target_comb

# target毎に各はみ出す数のパターン数を乗算したものの和が答え
answer = target_comb.inject(0) do |acc, comb|
  acc += comb.inject(1) do |acc_inner, v|
    acc_inner *= patterns_by_out_steps[v]
  end
end
p answer