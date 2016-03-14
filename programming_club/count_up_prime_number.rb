class Solver
  def initialize limit
    @limit = limit
    @primes = []
  end

  def solve
    (2...@limit).each do |num|
      is_prime = true
      @primes.each do |prime|
        if num % prime == 0
          is_prime = false
          break
        end
      end
      @primes << num if is_prime
    end
    @primes
  end
end

while line = STDIN.gets
  solver = Solver.new line.chomp.to_i
  p solver.solve
end