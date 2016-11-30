class Array
  def histgram
    self.inject({}) do |acc, value|
      key = block_given? ? (yield value) : value
      acc[key] = (acc[key] || 0) + 1
      acc
    end
  end
end

class Solver
  DENOMINATOR = 1000003

  def initialize n
    @n = n

    @prime = []
    (2..n).each do |candidate|
      is_prime = true
      @prime.each do |div|
        if candidate % div == 0
          is_prime = false
          break
        end
      end
      @prime << candidate if is_prime
    end
  end

  def factorization num
    factors = []
    org = num
    while num != 1
      @prime.each do |factor|
        if num % factor == 0
          factors << factor
          num = num / factor
          break
        end
      end
    end
    factors
  end

  def solve
    # 素因数分解
    factors = (1..@n).to_a.inject(Hash.new(0)) do |acc, num|
      factorization(num).histgram.each do |factor, frequency|
        acc[factor] = acc[factor] + frequency * @n
      end
      acc
    end

    # 約数の足し上げ
    divisor_sum = factors.inject(1) do |acc, (factor, frequency)|
      factor_sum = (1 - factor ** (frequency + 1)) / (1 - factor)
      factor_rest = factor_sum % Solver::DENOMINATOR
      (acc * factor_rest)
    end
    divisor_sum % Solver::DENOMINATOR
  end
end


n = STDIN.gets.chomp.to_i
solver = Solver.new(n)
puts solver.solve
