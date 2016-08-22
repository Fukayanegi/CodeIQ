require 'set'

def factorial n
  return 1 if n < 1
  (1..n).to_a.inject{|acc, v| acc * v}
end

def combination n, r
  permutation(n,r) / factorial(r)
end

def permutation n, r
  factorial(n) / factorial(n - r)
end

cp, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}

def build_ng_binary cp_h, n, target, base, base_nums
  ng_patterns = {}
  return ng_patterns if target > cp_h.downto(cp_h - n + 1).inject(:+)

  limit = cp_h - n > 0 ? n : 1
  cp_h.downto(limit) do |cp_1|
    if base ^ (1 << cp_1 - 1) >= base
      if n > 2
        # 3体以上のモンスターを選択する余地がある場合は、cp_1を減算した値をtargetとして再帰 
        tmp_ng = build_ng_binary cp_1 - 1, n - 1, target - cp_1, base + (1 << cp_1 - 1), base_nums + 1
        ng_patterns.merge! tmp_ng
      elsif (cp_2 = target - cp_1) > 0 && cp_1 > cp_2
        # 2体のモンスターを選択する場合は必然的にcp_1とtarget-cp_1となる
        if base ^ (1 << cp_2 - 1) >= base
          ng_patterns[base + (1 << cp_1 - 1) + (1 << cp_2 - 1)] = base_nums + 2
        end
      end
    end
  end
  ng_patterns
end

def solve cp, n
  not_answer = Set.new
  1.upto(n/2) do |nums|
    # 基準の組み合わせ
    (1..cp).to_a.combination(nums).each do |target|
      # 基準の組み合わせのbinary表現
      base = target.inject(0){|acc, v| acc += 1 << v - 1}
      nums.upto(n - nums).each do |target_nums|
        # 基準の組み合わせの最大値以下のCPを持つモンスターで合計が等しくなる組み合わせ
        ng = build_ng_binary target.max - 1, target_nums, target.inject(:+), base, nums
        ng.each do |(binary, binary_nums)|
          # 合計が等しくなる組み合わせ + nに不足する数のモンスターを選択
          (1..cp).to_a.combination(n - binary_nums) do |add|
            # 排他的論理和で増加があれば重複がないため有効
            if add.inject(true){|acm, v| acm &= (binary ^ (1 << v - 1) >= binary)}
              not_answer << (binary ^ add.inject(0){|acm, v| acm += (1 << v - 1)})
            end
          end
        end
      end
    end
  end
  not_answer
end

not_answer = solve cp, n
puts combination(cp, n) - not_answer.length