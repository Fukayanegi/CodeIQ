class Solver
  @@target = "7"

  def initialize range_to
    @range_to = range_to
  end

  def solve
    answer = 0

    # 最上位の桁を固定相当の配列
    lower_digit = @range_to.to_s.length - 1
    lower_digits = (1..lower_digit).to_a

    # 最上位の桁
    upper_digit = @range_to.to_s[0].to_i
    # p "#{upper_digit}, #{lower_digit}, #{lower_digits}"

    (1..lower_digit).each do |select_num|
      # 最上位の桁を固定した場合にselect_numだけ7がある数字の数を答えに加算
      count_tmp = lower_digits.combination(select_num).to_a.count
      answer += count_tmp * select_num
    end
    # p "#{answer}"

    # 最上位の桁が7未満の場合、最上位の桁のパターン分answerが存在する（最上位0も含めて）
    answer = (upper_digit + 1) * answer
    if upper_digit >= 7
      # 最上位の桁が7以上の場合、最上位の桁=7の分answerが余計に存在する
      answer += 10 ** lower_digit
    end

    answer
  end
end

while (range_to = STDIN.gets) do
  solver = Solver.new range_to.chomp!.to_i
  p solver.solve
end