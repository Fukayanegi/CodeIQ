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

cp, n = STDIN.gets.chomp!.split(" ").map{|v| v.to_i}
p "#{cp}, #{n}"

def build_ng_binary cp_h, n, target, base, base_nums
  p "call_build_ng_binary: cp_h = #{cp_h}, n = #{n}, target = #{target}, base = #{base}"
  printf "base_binary: %0#{cp_h}b\n", base
  ng_patterns = {}
  return ng_patterns if target > cp_h.downto(cp_h - n + 1).inject(:+)

  limit = cp_h - n > 0 ? cp_h - n : 1
  cp_h.downto(limit) do |cp_1|
    if n > 2
      tmp = build_ng_binary cp_1 - 1, n - 1, target - cp_1, base + (1 << cp_1 - 1), base_nums + 1
      ng_patterns.merge! tmp
    elsif (cp_2 = target - cp_1) > 0 && cp_1 > cp_2
      p "#{cp_1}, #{cp_2}"
      tmp = (1 << cp_1 - 1) + (1 << cp_2 - 1)
      if base ^ tmp >= base
        # ng_patterns[base + (1 << cp_1 - 1) + (1 << cp_2 - 1)] = base_nums + 2
        ng_patterns[base ^ tmp] = base_nums + 2
      end
    end
  end
  ng_patterns
end

def solve cp, n
  not_answer = Set.new
  1.upto(n/2) do |nums|
    p "nums >= 2: #{nums}" if nums > 1
    (1..cp).to_a.combination(nums).each do |target|
    p "nums >= 2: #{target}" if nums > 1
      base = target.inject(0){|acc, v| acc += 1 << v - 1}
      # p "#{target}, #{base}, #{base.to_s(2)}"
      printf "nums >= 2: #{target}, #{base}, %0#{cp}b\n", base if nums > 1
      nums.upto(n - nums).each do |target_nums|
        ng = build_ng_binary target.max - 1, target_nums, target.inject(:+), base, nums
        # p ng
        ng.each do |(binary, binary_nums)|
          printf "binary: %0#{cp}b\n", binary
          (1..cp).to_a.combination(n - binary_nums) do |add|
            tmp = add.inject(0){|acm, v| acm += (1 << v - 1)}
            # printf "tmp: %0#{cp}b\n", tmp
            if binary ^ tmp >= binary
              not_answer << (binary ^ tmp)
              printf "ng_binary: %0#{cp}b\n", binary ^ tmp
            end
          end
        end
      end
    end
  end
  # not_answer.sort.each{|binary| printf "binary: %0#{cp}b\n", binary}
  # p combination(cp, n)
  combination(cp, n) - not_answer.length
end

p solve cp, n