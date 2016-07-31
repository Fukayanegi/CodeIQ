require 'set'

@p, @q = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

@primes = []
@limit = 1
# 素数配列作成
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

# 素数判定
def prime? num
  idx = @primes.length / 2
  delta = idx
  answer = true

  while delta > 0 && idx < @primes.length && idx >= 0
    target = @primes[idx]
    if target == num
      break
    end

    if delta > 1
      delta = (delta / 2.0).ceil
      if target < num
        idx = idx + delta
        idx = @primes.length - 1 if idx >= @primes.length
      else
        idx = idx - delta
        idx = 0 if idx < 0
      end
    else
      answer = false
      break
    end
  end

  answer
end

def convert_1 nums, limit, nums_next
  nums.each do |num|
    tmp = []
    left = num.to_s.length
    (1..9).each do |v|
      v1 = v * 10**left + num
      v2 = num * 10 + v
      tmp << v1 if prime? v1
      tmp << v2 if prime? v2
    end
    nums_next.concat tmp
  end

  nums_next.uniq!
  nums_next
end

def convert_2 nums, nums_next
  nums.each do |num|
    digit = num.to_s.length - 1
    return nums if digit < 1
    v1 = num % 10**digit
    v2 = num / 10
    nums_next << v1 if ((prime? v1) && (v1 > 10**(digit-1)))
    nums_next << v2 if prime? v2
  end

  nums_next.uniq!
  nums_next
end

# メインロジックここから

# 最初に素数配列を作成してしまう
make_primes @q
p @primes

num_convert = 0

# 重複探索を避けるための既出数値チェック
loop_chek_from = [@p]
loop_chek_to = [@q]

# 開始数値、終了数値両側からの探索初期値
# #{num_convert}回目の前数値の配列
# loop_chek_from,loop_check_toに存在している場合、
# もっとその数値に辿り着く方が最短になる変換ルートがあるはずなので除外する
nums_from_all = [@p]
nums_to_all = [@q]

while true do
  nums_from_next = []
  nums_to_next = []

  if nums_from_all.length == 0 || nums_to_all.length == 0
    num_convert = -1
    break
  end

  # TODO:
  # この辺は重複コードがあるのでリファクタできるかも
  convert_1 nums_from_all, @q, nums_from_next
  convert_2 nums_from_all, nums_from_next
  nums_from_next.select!{|f| !(loop_chek_from.include? f)}

  convert_1 nums_to_all, @q, nums_to_next
  convert_2 nums_to_all, nums_to_next
  nums_to_next.select!{|f| !(loop_chek_to.include? f)}

  if (nums_from_next & nums_to_all).length > 0
    num_convert += 1
    break
  end

  if (nums_from_next & nums_to_next).length > 0
    # p nums_from_next & nums_to_next
    num_convert += 2
    break
  end

  loop_chek_from |= nums_from_next
  loop_chek_to |= nums_to_next

  nums_from_all = nums_from_next
  nums_to_all = nums_to_next
  num_convert += 2
end

answer_tmp = num_convert
p (answer_tmp.nil? ? -1 : answer_tmp)