# コマンドライン引数に"-dlog"があった場合にログを出力する関数
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class PrimeJudger
  @@primes = []
  @@limit = 1
  # 素数配列作成
  def self.make_primes limit
    ((@@limit+1)..limit).each do |num|
      is_prime = true
      quotient = limit
      @@primes.each do |prime|
        # 判定対象が前回判定時の商を超える素数だった場合、
        # 以降の商は前回の素数を下回る（既に存在しないことが判定済）ため打ち切り
        if prime > quotient
          is_prime = true
          break
        end
        quotient = num / prime
        if num % prime == 0
          is_prime = false
          break
        end
      end
      @@primes << num if is_prime
    end
    @@limit = limit
  end

  def self.is_prime? number
    make_primes(@@limit + 1000) if @@limit < number
    @@primes.include?(number)
  end
end

class InfinitySequence
  include Enumerable
  def initialize
    @num = 1
  end

  def each
    loop do
      yield @num
      @num += 1
    end
  end
end

class Sequence
  include Enumerable
  attr_reader :org_sequence, :remove_before
  def initialize org_sequence, remove_before
    @org_sequence = org_sequence || InfinitySequence.new
    @remove_before = remove_before
  end

  def each
    pre_read = []
    org_sequence.each do |num|
      pre_read << num
      if pre_read.length == remove_before + 1
        if PrimeJudger::is_prime?(num)
          pre_read.shift
        else
          yield pre_read.shift
        end
      end
    end
  end
end

input = STDIN.gets.chomp.split(' ').map(&:to_i)
dlog({:input => input})

seq = input.inject(nil) do |acc, remove_before|
  Sequence.new(acc, remove_before)
end

answer = []
seq.take(10).each do |num|
  answer << num
end
puts answer.join(",")