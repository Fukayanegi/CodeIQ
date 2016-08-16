def factorial n
  return 1 if n < 1
  (1..n).to_a.inject{|acc, v| acc * v}
end

def combination n, r
  permutation(n,r) / factorial(r)
end

def permutation n, r
  factorial(n) / factorial(n - r)
end

@memo_groups = {}
def create_groups min_member, rest
  key = "#{min_member}:#{rest}"
  return [[rest]] if rest < min_member * 2
  return Marshal.load(Marshal.dump(@memo_groups[key])) if @memo_groups.include? key
  groups = [[rest]]

  min_member.upto(rest) do |member|
    break if rest - member < member
    tmp = (create_groups member, rest - member)
    tmp.each do |group|
      groups << (group.unshift member)
    end
  end

  @memo_groups[key] = groups
  # sleep 1
  Marshal.load(Marshal.dump(groups))
end

n = STDIN.gets.chomp.to_i

@memo = {}
def calc_e_value m
  # 全員が座席番号=申込番号のケース
  patterns = 1
  groups_sum = m

  # 座席番号と申込番号が等しい人数
  (0..m-2).each do |num_of_same|
    num_of_same_patterns = num_of_same == 0 ? 1 : combination(m, num_of_same)
    rest = m - num_of_same
    max_groups = rest / 2

    # p "m = #{m}, #{num_of_same}:start"
    # p "groups_sum = #{groups_sum}, patterns = #{patterns}, num_of_same_patterns = #{num_of_same_patterns}"

    count_m = {}
    if @memo.include? rest
      count_m = @memo[rest]
      patterns += num_of_same_patterns * count_m.values.inject(0, :+)
      groups_sum += num_of_same_patterns * count_m.inject(0){|acc, (key, value)| acc += (key + num_of_same) * value}
      # p "patterns = #{num_of_same_patterns * count_m.values.inject(0, :+)}, groups_sum = #{num_of_same_patterns * count_m.inject(0){|acc, (key, value)| acc += (key + num_of_same) * value}}"
    else
      memo = []
      (create_groups 2, rest).each do |members|
        groups = members.length

        # 残りrest個の数値に対してcut_pointは有効か？
        if members.all?{|member| member > 1} && !(memo.include? members)
          # p "rest = #{rest}, groups = #{groups}, members = #{members}"
          memo << members
          # p "groups = #{groups}, members = #{members}, num_of_same = #{num_of_same}"

          # restをmembers毎に分割していく組み合わせ数を乗算
          count = 1
          members.inject(rest) do |acc, group|
            # restからgroupのグループを作成できる組み合わせ数
            # p "rest = #{acc}, group = #{group}"
            cm = combination(acc, group)
            # p "combination(rest, group) = #{cm}"
            # group内の辿り順の場合の数
            # 先頭を固定する必要があるため、n = group - 1とする
            pm = permutation(group - 1, group - 1)
            # p "permutation(group - 1, group - 1) = #{pm}"
            tmp = cm * pm
            # p "tmp = #{tmp}"
            count *= tmp
            acc - group
          end
          
          # [[12], [34], [56]],[[43], [12], [56]]等の重複分を除算
          dup_comb = members.inject({}) do |acc_h, num_of_group|
            acc_h[num_of_group] = 0 if !(acc_h.include? num_of_group)
            acc_h[num_of_group] += 1
            acc_h
          end
          dup_comb = dup_comb.select{|k, v| v > 1}
          # p "dup_comb = #{dup_comb}"
          div_dup_comb = dup_comb.inject(1){|acm_d, (k, v)| acm_d * factorial(v)}
          # p "count = #{count}, div_dup_comb = #{div_dup_comb}"
          count = count / div_dup_comb

          patterns += num_of_same_patterns * count
          count_m[groups] = 0 if !(count_m.include? groups)
          count_m[groups] += count
          groups_sum += num_of_same_patterns * (groups + num_of_same) * count
          # p "patterns = #{num_of_same_patterns * count}, groups_sum = #{num_of_same_patterns * (groups + num_of_same) * count}"
        end
      end

      @memo[rest] = count_m
    end
  end

  p "m = #{m}, groups_sum = #{groups_sum}, patterns = #{patterns}, e = #{groups_sum / patterns.to_f}"
  groups_sum / patterns.to_f
end

m = n
while calc_e_value(m) <= n
  m += 1
end

puts m