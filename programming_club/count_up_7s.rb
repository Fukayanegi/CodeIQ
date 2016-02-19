class Solver
  @@target = "7"

  def initialize range_to
    @range_to = range_to
  end

  def solve
    return 0 if @range_to < 7
    return 1 if @range_to < 16
    answer = 0

    # 最上位の桁を固定相当の配列
    lower_digit = @range_to.to_s.length - 1
    lower_digits = (1..lower_digit).to_a

    # 最上位の桁
    upper_digit = @range_to.to_s[0].to_i
    # p "#{upper_digit}, #{lower_digit}, #{lower_digits}"

    (1..lower_digit).each do |select_num|
      # 最上位の桁を固定した場合にselect_numだけ7がある数字の数を答えに加算
      seven_pattern = lower_digits.combination(select_num).to_a.count
      others_pattern = 9 ** (lower_digit - select_num)  
      # p "#{select_num}: #{seven_pattern}, #{others_pattern}"
      answer += seven_pattern * others_pattern * select_num
    end
    # p "after_loop: #{answer}"

    # 最上位の桁が7未満の場合、最上位0から最上位の桁の数字-1のパターン * answer + 
    # 下位の桁の数字分7が存在する
    # 例）654321の場合、0~99999、100000~199999、200000~299999、300000~399999、400000~499999、500000~599999
    # + 54321までの7の数分が7存在する
    # p "#{upper_digit} * #{answer}: "
    answer = upper_digit * answer
    # p "#{answer}"

    nest_solver = Solver.new(@range_to % 10 ** lower_digit)
    answer += nest_solver.solve
    # p "#{answer}"

    # p "after_mulipul: #{answer}"
    if upper_digit == 7
      # p "#{@range_to % 10 ** lower_digit}"
      answer += @range_to % 10 ** lower_digit + 1
      # p "#{answer}"
    elsif upper_digit > 7
      # 最上位の桁が7超の場合、最上位の桁=7の分answerが余計に存在する
      answer += 10 ** lower_digit
    end

    answer
  end
end

while (range_to = STDIN.gets) do
  solver = Solver.new range_to.chomp!.to_i
  p solver.solve
end