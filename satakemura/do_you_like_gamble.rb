N = STDIN.gets.chomp.to_i

class Solver
  def initialize n
    @n = n
  end

  def next_number
    return Random.rand(@n) + 1
  end

  def solve tries
    es = Hash.new

    (1..@n).each do |limit|
      e = 0
      tries.times do |try|
        money = 0
        while (num = next_number) < limit do
          money -= 1
          # p "  #{limit}: #{num}"
        end
        money += num
        # p "#{limit}-#{try}: #{money}"
        e += (money - e) / (try + 1).to_f
      end
      p "#{limit}: #{e}"
      es[limit] = e
    end

    p es.sort{|(k1, v1),(k2, v2)| v2 <=> v1 }[0][0]
  end

end

solver = Solver.new N
solver.solve 1000