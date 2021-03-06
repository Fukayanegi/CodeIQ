total_books = STDIN.gets.chomp!.to_i

# n冊の本の中で最終的な配置の右からm冊が順序よく並んでいる場合の数
# m=2,n=4の場合、6
# * * 3 4
# * 3 * 4
# 3 * * 4
# * 3 4 *
# 3 * 4 *
# 3 4 * *
def count_m_is_ordered_in_n m, n
  return 0 if m > n
  return 1 if m == 0 || m == n

  # nに最大値を置いた場合
  c1 = count_m_is_ordered_in_n m - 1, n - 1
  # nに最大値を置かない場合
  c2 = count_m_is_ordered_in_n m, n - 1

  return c1 + c2
end

# 階乗を求める関数
def factorial(number)
  number = 0 if number.nil?
  (1..number).inject(1,:*)
end

class Solver
  def initialize total_books
    @total_books = total_books
  end

  def solve
    total_move = 0
    # 1..total_booksのラベルを持った本が並んでいるケースを考える
    @total_books.times do |pos|
      # pos = 最大値の場所とする

      left_books = pos
      right_books = @total_books - pos - 1

      # fix_books = 最短回数でソートした場合、posより左側で動かす必要のない本の数
      (0..left_books).each do |fix_books|
        # posより左側でfix_booksが順序よく並んでいるパターン数をカウント
        fix_patterns = count_m_is_ordered_in_n fix_books, left_books
        # p "fix_patterns: #{left_books}, #{fix_books}, #{fix_patterns}"

        # 除外する場合の数をカウント
        # (left_booksの中に(@total_books - fix_books - 1)のラベルを持った本が
        # (@total_books - fix_books)のラベルを持った本より左側にある場合の数)
        # @total_books=7,left_books=4、fix_books=2の場合、
        # 下記の「4 * 5 6 7 * *」、「* 4 5 6 7 * *」、「4 5 * 6 7 * *」、「4 5 6 * 7 * *」のケース
        # = 4 * 3! = 24
        # * * 5 6 7 * *
        # * 5 * 6 7 * *
        # 5 * * 6 7 * *
        # 5 * 6 * 7 * *
        # * 5 6 * 7 * *
        # 5 6 * * 7 * *
        exculde_patterns = count_m_is_ordered_in_n(fix_books + 1, left_books) * factorial(@total_books - fix_books - 2)
        # p "exculde_patterns: #{left_books}, #{fix_books}, #{exculde_patterns}"

        patterns = fix_patterns * factorial(@total_books - fix_books - 1) - exculde_patterns
        total_move += patterns * (@total_books - fix_books - 1)
      end
    end

    total_move
  end
end

solver = Solver.new total_books
p solver.solve