class Solver
  def initialize players
    @players = players
    @line = Array.new @players * 2
    @memo = Hash.new
  end

  def create_key line, players
    players.to_s + ">>" + line.map{|pos| pos.nil? ? "0" : "*"}.join(":")
  end

  def solve max_number
    return 1 if max_number == 0
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key @line, max_number
    p key
    return @memo[key] if @memo.include? key

    # 探索
    answer = 0
    @line.each_with_index do |pos, i|
      j = i + max_number + 1
      if pos.nil? && j < @line.length && @line[j].nil?
        @line[i] = max_number
        @line[j] = max_number
        p @line
        answer += solve(max_number - 1)
        @line[i] = nil
        @line[j] = nil
      end
    end

    @memo[key] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
p solver.solve players