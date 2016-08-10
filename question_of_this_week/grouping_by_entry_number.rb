n = STDIN.gets.chomp.to_i

def calc_e_value m
  # 全員が座席番号=申込番号のケース
  patterns = 1
  groups_sum = m

  # 座席番号と申込番号が等しい人数
  (0..m-1).each do |num_of_same|
    num_of_same_patterns = num_of_same == 0 ? 1 : (1..m).to_a.combination(num_of_same).to_a.length
    rest = m - num_of_same
    max_groups = rest / 2

    # p "#{num_of_same}:start, groups_sum = #{groups_sum}, patterns = #{patterns}"

    (1..max_groups).each do |groups|
      # p "num_of_same = #{num_of_same}, rest = #{rest}, groups = #{groups}"
      (1..rest).to_a.combination(groups - 1).each do |cut_point|
        menbers = cut_point.unshift(0).push(rest).each_cons(2).map{|t, n| n - t}

        # 残りrest個の数値に対してcut_pointは有効か？
        if menbers.all?{|member| member > 1}
          # 座席番号と申し込み番号が等しい人数の組み合わせ数を初期値に
          count = num_of_same == 0 ? (1..m-1).inject(1){|acc, this| acc * (m - this)} : num_of_same_patterns

          # restをmenbers毎に分割していく組み合わせ数を乗算
          menbers.inject(rest) do |acc, this|
            # TODO: 場合の数でlengthを求める
            count *= (1..acc).to_a.combination(this).to_a.length
            # p "acc = #{acc}, this = #{this}, count = #{count}"
            acc - this
          end
          patterns += count
          groups_sum += (menbers.length + num_of_same) * count
          # p "count = #{count} menbers = #{menbers}, groups_sum = #{groups_sum}"
        end
      end
    end
  end

  # p "m = #{m}, groups_sum = #{groups_sum}, patterns = #{patterns}, e = #{groups_sum / patterns.to_f}"
  groups_sum / patterns.to_f
end

m = n
while calc_e_value(m) <= n
  m += 1
end

puts m