class Solver
  attr_accessor :hit, :total

  def initialize players
    @players = Array.new(players) {|i| i + 1}
    @line = Array.new players * 2
    @memo = Hash.new
    @hit = 0
    @total = 0
  end

  def create_key
    pattern = @line.map{|pos| pos.nil? ? "0" : "*"}.join(":")
    # pattern = pattern.scan(/^((\*:)*)(.+?)((:\*)*)$/)[0][2]
    # filled_pos = pattern.index("*")
    # pattern.reverse! if !filled_pos.nil? && filled_pos > pattern.length / 2
    # p pattern
    @players.join(":") + ">>" + pattern
  end

  def solve line_i
    @total += 1
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key
    p key

    return 1 if @players.length == 0
    if @memo.include? key
      @hit += 1
      # p "cached answer ***** >> #{key}, #{@memo[key]}"
      return @memo[key] 
    end

    # 探索
    answer = 0
    # 左から選手を埋めていく
    (@players.length - 1).downto(0) do |player_i|
      player = @players.slice! player_i
      line_j = line_i + player + 1
      
      # 反対側の選手の位置が範囲を越えていた場合、以降の探索は中止
      if line_j >= @line.length
        @players.insert player_i, player
        break
      end
      
      if @line[line_i].nil? && @line[line_j].nil?
        @line[line_i] = player
        @line[line_j] = player
        # p @line
        answer += solve @line.index nil
        @line[line_i] = nil
        @line[line_j] = nil
      end

      @players.insert(player_i, player)
    end

    # p "memoization ******* >> #{key}, #{answer}, #{@line}"
    @memo[key] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
# p 35584
p solver.solve 0
p "cache hit ********* >> #{solver.total}, #{solver.hit}"