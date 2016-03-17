class Solver
  attr_accessor :hit, :total

  def initialize players
    @players = players
    @line = Array.new @players * 2
    @memo = Hash.new
    @hit = 0
    @total = 0
  end

  def create_key line, players
    pattern = line.map{|pos| pos.nil? ? "0" : "*"}.join(":")
    pattern = pattern.scan(/^((\*:)*)(.+?)((:\*)*)$/)[0][2]
    filled_pos = pattern.index("*")
    pattern.reverse! if !filled_pos.nil? && filled_pos > pattern.length / 2
    # p pattern
    players.to_s + ">>" + pattern
  end

  def solve max_number
    @total += 1
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key @line, max_number
    # p key

    return 1 if max_number == 0
    if @memo.include? key
      @hit += 1
      # p "cached answer ***** >> #{key}, #{@memo[key]}"
      return @memo[key] 
    end

    # 探索
    answer = 0
    @line.each_with_index do |pos, i|
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
          break if k >= @line.length && l < 0
          # p "possibility ******* >> number:#{number}, #{pos}, #{@line[k]}, #{@line[l]}"
          if (k < @line.length && @line[k].nil?) || (l >= 0 && @line[l].nil?)
            impossible = false
            break
          end
        end
        break if impossible
      end
    end

    # p "memoization ******* >> #{key}, #{answer}, #{@line}"
    @memo[key] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
# p 35584
p solver.solve players
p "cache hit ********* >> #{solver.total}, #{solver.hit}"