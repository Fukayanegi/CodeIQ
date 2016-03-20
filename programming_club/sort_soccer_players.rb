class Solver
  attr_accessor :hit, :total, :memo

  def initialize players
    @players = players
    @fmt = "%0" + (@players * 2).to_s + "d"
    @max_val = ("1" * players * 2).to_i(2)
    @memo = Hash.new
    # @hit = 0
    # @total = 0
  end

  def solve orders, max_number
    # @total += 1
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = orders
    key_rev = ((@fmt % orders.to_s(2)).reverse).to_i
    # key_rev = key.reverse
    # p key

    return 1 if max_number == 0
    if @memo.include? key
      # @hit += 1
      # p "cached answer ***** >> #{key}, #{@memo[key]}"
      return @memo[key] 
    end
    # p "uncached ********** >> #{key}"

    # 探索
    answer = 0
    mask = (1 << max_number + 1) + 1
    0.upto(@players * 2 - 1).each do
      break if mask > @max_val
      if orders & mask == 0
        answer += solve(orders | mask, max_number - 1)
      end
      mask = mask << 1
    end

    # p "memoization 0 ***** >> #{key}, max_number:#{max_number}, answer:#{answer}, #{@line}"
    @memo[key] = answer
    @memo[key_rev] = answer

    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
p solver.solve 0, players
p "memo length ******* >> #{solver.memo.length}"
# p "cache hit ********* >> #{solver.total}, #{solver.hit}"