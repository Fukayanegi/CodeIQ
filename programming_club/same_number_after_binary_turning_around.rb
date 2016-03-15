class Solver
  def initialize from, to
    @from = from
    @to = to
  end

  # FIXME: count_under_fromとcount_upper_toは似たようなロジックとなっているため
  # まとめられる気がする

  def count_under_from length
    half_length = length / 2
    left = @from.to_s(2)[0..(half_length - 1)]
    left_min = "1" + "0" * (half_length - 1)
    # p "*" * 20 + "under_digits" + "*" * 20
    # p "length: #{length}"
    # p "left_digits: #{left} -> #{left.to_i(2)}"
    # p "left_digits_min: #{left_min} -> #{left_min.to_i(2)}"

    # 上位半数桁の最小数〜下限の上位半数桁までの数のパターン数
    # 桁数が奇数の場合2倍
    # ただし、下限の上位半数桁の反転数が下限を超えるの場合は除く
    answer = 0
    if length.even?
      answer += left.to_i(2) - left_min.to_i(2) + 1
      answer -= 1 if (left + left.reverse).to_i(2) > @from
    else
      answer += (left.to_i(2) - left_min.to_i(2) + 1) * 2
      answer -= 1 if (left + "0" + left.reverse).to_i(2) > @from
      answer -= 1 if (left + "1" + left.reverse).to_i(2) > @from
    end
    # p "answer: #{answer}"
    answer
  end

  def count_upper_to length
    half_length = length / 2
    left = @to.to_s(2)[0..(half_length - 1)]
    left_full = "1" * half_length
    # p "*" * 20 + "upper_digits" + "*" * 20
    # p "length: #{length}"
    # p "left_digits: #{left} -> #{left.to_i(2)}"
    # p "left_digits_full: #{left_full} -> #{left_full.to_i(2)}"

    # 上限の上位半数桁〜上限の上位桁が全て1の数のパターン数
    # 桁数が奇数の場合2倍
    # ただし、上限の上位半数桁の反転数が上限未満の場合は除く
    answer = 0
    if length.even?
      answer += (left_full.to_i(2) - left.to_i(2) + 1)
      answer -= 1 if (left + left.reverse).to_i(2) <= @to
    else
      answer += (left_full.to_i(2) - left.to_i(2) + 1) * 2
      answer -= 1 if (left + "0" + left.reverse).to_i(2) < @to
      answer -= 1 if (left + "1" + left.reverse).to_i(2) < @to
    end
    answer
  end

  def solve
    under_digits = @from.to_s(2).length
    upper_digits = @to.to_s(2).length
    # p "digits: #{under_digits}, #{upper_digits}"

    answer = 0
    under_digits.upto(upper_digits) do |target_digits|
      # 桁数の半分さの2進数で反転となる数を考える
      # 桁数が奇数の場合、真ん中の桁を挟んだ長さ
      # 最上位桁は1
      # 桁数が奇数の場合真ん中の桁は0/1どちらでも可なので2倍
      # 01 0 10 => 実際には4桁の数のためNG
      # 10 0 01 => OK
      # 10 1 01 => OK
      answer += 2**(target_digits / 2 - 1)
      answer += 2**(target_digits / 2 - 1) if target_digits.odd?

      # @from以下の数を除く
      answer -= count_under_from target_digits if target_digits == under_digits
      # @to以上の数を除く
      answer -= count_upper_to target_digits if target_digits == upper_digits

      # p "answer: #{target_digits}, #{answer}"
    end
    answer
  end
end

from, to = STDIN.gets.chomp.split(",").map{|val| val.to_i}
# p "input: #{from}, #{to}"
# p "input_by_binary: #{from.to_s(2)}, #{to.to_s(2)}"

solver = Solver.new from, to
p solver.solve