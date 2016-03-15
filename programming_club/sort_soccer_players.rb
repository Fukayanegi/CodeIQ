class Solver
  def initialize players
    @players = players
    @line = Array.new @players * 2
    @memo = Hash.new
  end

  def create_key line, players
    players.to_s + ">>" + line.join(":")
  end

  def solve max_number
    # メモ化のためのkey生成
    # 配列の空きパターンと残りの選手
    key = create_key @line, max_number
    return @memo[key] if @memo.include? key

    # 探索
    answer = 0
    @line.each_with_index do |pos, i|
    end

    @memo[key] = answer
    answer
  end
end

players = STDIN.gets.chomp.to_i
solver = Solver.new players
p solver.solve players