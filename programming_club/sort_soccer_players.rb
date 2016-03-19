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
    # pattern = pattern.scan(/^((\*:)*)(.+?)((:\*)*)$/)[0][2]
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
      # p "cached answer ***** >> #{key}, #{@memo[key]}"
      return @memo[key] 
    end
    # p "uncached ********** >> #{key}"

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
    p "memoization 0 ***** >> #{key}, max_number:#{max_number}, answer:#{answer}, #{@line}"
    @memo[key] = answer
    @memo[key_rev] = answer

    if answer == 0
      max_number.upto(@line.length / 2) do |number|
      end
    end

    answer
  end
end

class Solver_new
  attr_accessor :hit, :total, :memo

  def initialize players
    @players = players
    @line = Array.new players * 2
    @memo = Hash.new
    @hit = 0
    @total = 0
  end

  def create_key
    pattern = @line.map{|pos| pos.nil? ? "0" : "*"}.join(":")
    pattern
  end

  def solve_rev max_number
    return 1 if max_number == @players
    answer = 0
    @line.each_with_index do |pos, i|
      j = i + max_number + 1
      break if j >= @line.length
      if !pos.nil? && !@line[j].nil?
        tmp = @line[i]
        @line[i] = nil
        @line[j] = nil
        key = create_key
        # p "key *************** >> #{key}"
        if @memo.include? key
          answer += @memo[key]
        else
          @memo[key] = 0
          @memo[key.reverse] = 0
        end
        @line[i] = tmp
        @line[j] = tmp
      end
    end
    # p "solve_rev_answer ** >> #{answer}"
    answer
  end

  def solve next_player
    @line.each_with_index do |pos, i|
      j = i + next_player + 1
      break if j >= @line.length
      if pos.nil? && @line[j].nil?
        @line[i] = next_player
        @line[j] = next_player
        key = create_key
        # p "key *************** >> #{key}"
        # p "#{key}, #{@memo[key]}" if (@memo.include? key)
        # if !(@memo.include? key)
          # p "line ************** >> #{@line}"
          answer_tmp = solve_rev next_player
          # p "answer ************ >> #{answer_tmp}"
          @memo[key] = answer_tmp
          @memo[key.reverse] = answer_tmp
        # end
        if next_player - 1 > 0
          solve(next_player - 1)
        end
        @line[i] = nil
        @line[j] = nil
      end
    end
  end

end

players = STDIN.gets.chomp.to_i
solver = Solver_new.new players
# p 35584
# p solver.solve players
solver.solve players
p solver.memo[("*:" * players * 2)[0..-2]]
p "memo length ******* >> #{solver.memo.length}"
p "memo 0 count ****** >> #{solver.memo.select{|key, val| val == 0}.length}"
p "cache hit ********* >> #{solver.total}, #{solver.hit}"