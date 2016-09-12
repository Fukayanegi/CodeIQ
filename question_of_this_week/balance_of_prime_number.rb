require 'set'
m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

# 素数配列作成
@primes = []
@limit = 1
def make_primes limit
  ((@limit+1)..limit).each do |num|
    is_prime = true
    quotient = limit
    @primes.each do |prime|
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
    @primes << num if is_prime
  end
  @limit = limit
end

def compute_range primes
  sum_range = {}
  (0..primes.length).each do |len|
    sum_min =len == 0 ? [0] : primes[0..len-1]
    sum_max = len == 0 ? [0] : primes[primes.length-len..primes.length-1]
    sum_range[len] = [sum_min.inject(:+), sum_max.inject(:+)]
  end
  sum_range
end

make_primes m
p @primes
sum_all = @primes.inject(:+)
sum_range = compute_range @primes
p sum_range

@memo = {0 => [], sum_all => @primes}
1.upto(@primes.length / 2) do |less|
  @primes.combination(less).each do |choices_l|
    key = choices_l.inject(:+)
    if !@memo.include? key
      @memo[key] = []
      @memo[sum_all - key] = []
    end
    @memo[key] << choices_l
    @memo[sum_all - key] << @primes - choices_l
  end
end

# @answer = Set.new
# 0.upto(@primes.length / 2) do |less|
#   less_min_min, less_max_max = sum_range[less]
#   @primes.combination(less).each do |choices_l|
#     sum_l = choices_l.length > 0 ? choices_l.inject(:+) : 0
#     less_min, less_max = sum_l - n, sum_l + n

#     (@primes.length - less).downto(less) do |many|
#       many_min, many_max = sum_range[many]
#       p "many[#{many}]: #{many_min}, #{many_max}"
#       next if (many_max < less_min) || (less_max < many_min)

#       p "num of count : #{less}, #{many}"
#       (@primes - choices_l).combination(many).each do |choices_m|
#         sum_m = choices_m.length > 0 ? choices_m.inject(:+) : 0
#         if (sum_l - sum_m).abs == n
#           # p "#{sum_l}, #{sum_m}"
#           tmp_1, tmp_2 = choices_l, choices_m if sum_l <= sum_m
#           tmp_1, tmp_2 = choices_m, choices_l if sum_l > sum_m
#           p "**anseer** : #{tmp_1}, #{tmp_2}"
#           @answer << "#{tmp_1}:#{tmp_2}"
#         end
#       end
#     end
#   end
# end
# p @answer.count
