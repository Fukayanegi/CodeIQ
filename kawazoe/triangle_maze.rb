class Solver
  @@dividend = 1000003
  attr_accessor :n

  def initialize n
    @n = n
    @memo = []
  end

  def solve
    answer = 1
    (@n - 1).times do |time|
      if @memo.include? answer
        loop_start = @memo.find_index answer
        loop_end = @memo.length
        loop_rest = @memo[loop_start..loop_end-1]
        loop_len = loop_end - loop_start
        answer = loop_rest[(@n - time) % loop_len - 1]
        # p "time:#{time}, answer:#{answer}, @memo:#{loop_rest[0]}, @memo:#{loop_rest[(@n - time) % loop_len - 1]}"
        break
      end
      @memo << answer
      answer = (answer * (answer + 1)) % @@dividend
    end
    answer
  end
end

n = STDIN.gets.chomp.to_i

solver = Solver.new n
puts solver.solve
