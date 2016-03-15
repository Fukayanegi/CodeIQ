class Solver
  def initialize players
    @players = players
    @line = Array.new @players * 2
    @memo = Hash.new
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
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key @line, max_number
    # p key
    # if max_number == 0
    #   p "*" * 20 + "answer" + "*" * 20
    #   p @line
    #   p "*" * 20 + "answer" + "*" * 20
    # end

    return 1 if max_number == 0
    return @memo[key] if @memo.include? key

    # 探索
    answer = 0
    @line.each_with_index do |pos, i|
      j = i + max_number + 1
      if pos.nil? && j < @line.length && @line[j].nil?
        @line[i] = max_number
        @line[j] = max_number
        # p @line
        answer += solve(max_number - 1)
        @line[i] = nil
        @line[j] = nil
      end
    end

    # p "*" * 20 + "memoization" + "*" * 20
    # p key
    # p @line
    # p answer
    # p "*" * 20 + "memoization" + "*" * 20    
    @memo[key] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
p 35584
# p solver.solve players