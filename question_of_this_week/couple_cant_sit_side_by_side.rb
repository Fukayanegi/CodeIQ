n = STDIN.gets.chomp.to_i

class Solver
  def initialize couples
    @couples = Array.new(couples) {|i| i}
    @memo = Hash.new
  end

  def count_patterns mens, seats, ladies
    # p "count_patterns >> #{mens}, #{seats}, #{ladies}"
    #️ 空いている席に何人が座れるかの並びをキーにする
    key_tmp = mens[-1*ladies.length-1..-1]
    key = ""
    key_tmp.each_cons(2) do |both_sides|
      key = key + ":" + (ladies - both_sides).length.to_s
    end
    key = "#{ladies.length}" + key
    # key = mens.join(":") + ">>" + ladies.join(":")

    # 3 4 0
    #  ? ?
    # ladies = 1, 4のような場合、keyは2:1:1となるが、4はどこにも置けず1はどちらでも置ける
    # 状態である1:1のため答えは0となるが
    # ladies = 1, 3の場合もkeyは2:1:1:となるが答えは1
    # この状態を区別するため前者の場合は答えをメモ化せずに0でリターン
    if ladies.length == 2 && (ladies - [key_tmp[1]]).length <= 1
      return 0
    end

    if @memo.include? key
      # p key
      return @memo[key] 
    end

    c_ladies = ladies.length
    if c_ladies == 0
      # p seats
      return 1 
    end

    answer = 0
    # 順番に女を着席させる
    c_ladies.times do |i|
      if mens[seats.length] != ladies[i] && mens[seats.length + 1] != ladies[i]
        lover = ladies.delete_at i
        seats << lover
        answer += count_patterns mens, seats, ladies
        seats.pop
        # p seats
        ladies.insert(i, lover)
      end
      # p ladies
    end    
    # p "#{key}: #{answer}"
    # p "answer: #{mens}, #{key_tmp}, #{ladies}, #{key}, #{answer}"
    @memo[key] = answer
    answer
  end

  def solve
    ladies = @couples.dup
    seats = Array.new

    # カップルが4組の場合で男が0,1,2,3の順に女の席を空けて並んだ状態を下記の配列で表現し、
    # 着席可能な状態を数え上げる
    # 0 1 2 3 0
    #  ? ? ? ?
    answer = 0
    @couples.permutation.each do |mens|
      # 円形の並びが前提となるため最初の要素は0固定で考える
      if mens[0] == 0
        answer += count_patterns mens << 0, seats, ladies
      end
    end

    # puts @memo
    answer
  end
end

solver = Solver.new n
puts solver.solve