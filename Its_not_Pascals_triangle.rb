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

@memo = Hash.new

def solve row, col
  return 0 if col < 1
  return 1 if col == 1
  return Fibonacci[col] if row == 0
  key = "#{row}:#{col}"
  return @memo[key] if @memo.include? key

  value_previous = solve row, col - 1
  value_previous2 = solve row, col - 2
  value_diff = solve row - 1, col

  @memo[key] = value_previous2 + value_previous + value_diff
  return @memo[key]
end

base_row = "a".ord
base_col = "A".ord

position = STDIN.gets.chomp!
row , col = position[0].ord - base_row, position[1].ord - base_col + 1

puts solve row, col