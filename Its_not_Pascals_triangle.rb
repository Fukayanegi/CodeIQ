base_row = "a".ord
base_col = "A".ord

position = STDIN.gets.chomp!
row , col = position[0], position[1]

# from http://blog.h13i32maru.jp/entry/20101016/1287227174
module Fibonacci
  @@memo = [0 , 1];

  def self.[](n)
    if @@memo.size <= n
      @@memo[n - 1] = self[n - 1] unless @@memo[n - 1];
      @@memo[n] = @@memo[n - 2] + @@memo[n - 1];
    end

    return @@memo[n];
  end
end

fib = Fibonacci[26]

p "#{row.ord - base_row}, #{col.ord - base_col}"
