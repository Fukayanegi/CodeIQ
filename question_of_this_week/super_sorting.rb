total_books = STDIN.gets.chomp!.to_i

# m=2,n=4の場合、6
# * * 1 2
# * 1 * 2
# 1 * * 2
# * 1 2 *
# 1 * 2 *
# 1 2 * *
def count_m_is_ordered_in_n m, n
  return 0 if m > n
  return 1 if m == 0 || m == n

  # nに最大値を置いた場合
  c1 = count_m_is_ordered_in_n m - 1, n - 1
  # nに最大値を置かない場合
  c2 = count_m_is_ordered_in_n m, n - 1

  return c1 + c2
end

total_books.times do |pos|
  # pos = 最大値の場所とする

  left_books = pos + 1
  right_books = total_books - pos + 1

  # fix_books = 最短回数でソートした場合、posより左側で動かす必要のない本の数
  (1..left_books).each do |fix_books|
    # posより左側でfix_booksが順序をもって並んでいるパターン数をカウント
    fix_patterns = count_m_is_ordered_in_n fix_books, left_books
    p "fix_patterns: #{left_books}, #{fix_books}, #{fix_patterns}"
  end
end