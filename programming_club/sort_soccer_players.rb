class Solver
  attr_accessor :hit, :total, :memo

  def initialize players
    @line = Array.new players * 2
    @memo = Hash.new
    @hit = 0
    @total = 0
  end

  def create_key
    pattern = @line.map{|pos| pos.nil? ? "0" : "*"}.join(":")
    pattern = pattern.scan(/^((\*:)*)(.+?)((:\*)*)$/)[0][2]
    pattern
  end

  def longest_interval key
    return 0
    head = key.scan(/^0:((\*:)+)0/)[0]
    head_len = head.nil? ? 0 : head.length / 2
    tail = key.scan(/0:((\*:)+)0$/)[0]
    tail_len = tail.nil? ? 0 : tail.length / 2
    head_len >= tail_len ? head_len : tail_len
  end

  def solve max_number
    @total += 1
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key
    key_rev = key.reverse
    # p key

    return 1 if max_number == 0
    if @memo.include? key
      @hit += 1
      p "cached answer ***** >> #{key}, #{@memo[key]}"
      return @memo[key] 
    end
    p "uncached ********** >> #{key}"

    # 探索
    answer = 0
    @line.each_with_index do |pos, i|
      # 配置可能な場所の最短間隔がmax_numberを超える場合、解はない
      # p "longest interval ** >> #{longest_interval key}, #{max_number}, #{@line}"
      if (longest_interval key) > max_number
        break
      else
        j = i + max_number + 1
        break if j >= @line.length
        if pos.nil? && @line[j].nil?
          @line[i] = max_number
          @line[j] = max_number
          # p @line
          answer += solve(max_number - 1)
          @line[i] = nil
          @line[j] = nil
        elsif pos.nil?
          # 対象の場所に配置できる選手がいるか確認
          # いなければこの空きパターンの答えは0
          # p "possibility ******* >> #{@line}, #{pos}, #{@line[j]}"
          impossible = true
          (max_number - 1).downto(1) do |number|
            k = i + number + 1
            l = i - (number + 1)
            # p "possibility ******* >> number:#{number}, #{pos}, #{@line[k]}, #{@line[l]}"
            if (k < @line.length && @line[k].nil?) || (l >= 0 && @line[l].nil?)
              impossible = false
              break
            end
          end
          break if impossible
        end
      end
    end

    # p "memoization ******* >> #{key}, max_number:#{max_number}, answer:#{answer}, #{@line}" if max_number <= 3
    @memo[key] = answer
    @memo[key_rev] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
# p 35584
p solver.solve players
p "memo length ******* >> #{solver.memo.length}"
p "cache hit ********* >> #{solver.total}, #{solver.hit}"