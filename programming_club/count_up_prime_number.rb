class Solver
  def initialize limit
    @limit = limit
    @primes = []
  end

  def solve
    (2...@limit).each do |num|
      is_prime = true
      quotient = @limit
      @primes.each do |prime|
        # p "#{num}, #{prime} >> prime > quotient : #{prime > quotient}"
        # 判定対象が前回判定時の商を超える素数だった場合、
        # 以降の商は前回の素数を下回る（既に存在しないことが判定済）ため打ち切り
        if prime > quotient
          is_prime = true
          break
        end
        quotient = num / prime
        # p "#{num}, #{prime} >> num % prime : #{num % prime}"
        if num % prime == 0
          is_prime = false
          break
        end
      end
      @primes << num if is_prime
    end
    # p @primes
    @primes.length
  end
end

while line = STDIN.gets
  solver = Solver.new line.chomp.to_i
  p solver.solve
end