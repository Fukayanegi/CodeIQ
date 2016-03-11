n = STDIN.gets.chomp.to_i

class Solver
  def initialize couples
    @couples = Array.new(couples) {|i| i}
    @memo = Hash.new
  end

  def count_patterns mens, seats, ladies
    # p "count_patterns >> #{mens}, #{seats}, #{ladies}"
    key = mens.join(":") + ">>" + ladies.join(":")
    return @memo[key] if @memo.include? key

    c_ladies = ladies.length
    if c_ladies == 0
      # p seats
      return 1 
    end

    answer = 0
    c_ladies.times do |i|
      lover = ladies.delete_at i
      if mens[seats.length] != lover && mens[(seats.length + 1) % mens.length] != lover
        seats << lover
        answer += count_patterns mens, seats, ladies
        seats.pop
        # p seats
      end
      ladies.insert(i, lover)
      # p ladies
    end    
    # p "#{key}: #{answer}"
    @memo[key] = answer
    answer
  end

  def solve
    ladies = @couples.dup
    seats = Array.new

    answer = 0
    @couples.permutation.each do |mens|
      if mens[0] == 0

        answer += count_patterns mens, seats, ladies
      end
    end

    answer
  end
end

solver = Solver.new n
puts solver.solve