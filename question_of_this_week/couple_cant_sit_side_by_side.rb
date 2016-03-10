couples = STDIN.gets.chomp!.to_i

class Solver
  def initialize couples
    @couples = Array.new
    couples.times do |i| 
      @couples << i
      @couples << i
    end
    @seat = Array.new(couples * 2)
  end

  def count_patterns seat, couples, sex
    # p "count_patterns >> #{seat}, #{couples}, #{sex}"
    return 1 if couples.length == 0

    patterns = 0

    lover = couples.shift
    # p "lover: #{lover}"
    (@seat.length / 2).times do |i|
      seat_i = 2 * i + sex
      left_i, right_i = (seat_i - 1) % seat.length, (seat_i + 1) % seat.length

      # p "left >> index: #{left_i}, value: #{seat[left_i]}"
      # p "right >> index: #{right_i}, value: #{seat[right_i]}"
      if seat[left_i] != lover && seat[right_i] != lover && seat[seat_i].nil?
        seat[seat_i] = lover 
        next_sex = sex == 0 ? 1 : 0
        patterns += count_patterns seat, couples, next_sex
        seat[seat_i] = nil
      end
    end
    couples.push lover
    patterns
  end

  def solve
    @seat[0] = @couples.shift 

    count_patterns @seat, @couples, 1
  end
end

solver = Solver.new couples
puts solver.solve