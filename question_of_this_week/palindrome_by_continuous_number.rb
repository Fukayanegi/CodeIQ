
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Solver
  def initialize n
    @n = n
  end

  def perse palindromes
    palindromes.map do |palindrome|
      palindrome.each_slice(2).map{|num, repeat| num * repeat.to_i}.join.to_i
    end
  end

  def filter numbers
    min = 10 ** (@n-1)
    max = 10 ** @n
    tmp = numbers.select{|num| num >= min && num < max}
  end

  def split_number total, split, min_value
    # dlog({:total => total, :split => split, :min_value => min_value})
    return [] if total / split < min_value
    return [[total]] if split == 1

    answer = []
    min_value.upto(total / split) do |num|
      tmp = split_number(total - num, split - 1, num)
      tmp = tmp.select{|n| n != []}.map!{|n| n.unshift(num)}
      answer.concat(tmp)
    end
    answer
  end

  def make_palindromes palindrome_half_length, digits
    # dlog({:palindrome_half_length => palindrome_half_length, :digits => digits})
    # if palindrome_half_length.even?
    # else
    #   split = (palindrome_half_length - 1) / 2 + 1
    # end

    split = palindrome_half_length
    splited = split_number(@n, split, 1)
    dlog({:split_number => splited})
    # 1 2 2 => 1 2 2 2 2 1 => 2が重なりNG
    # 1 2 1 => 1 2 1 1 2 1 => 1が重なりNG
    # 1 2 2 2 => 1 2 2 2 2 2 2 1 => 2が重なりNG
    # 1 3 2 2 => 1 3 2 2 2 2 3 1 => 2が重なりNG
    valid_palindrome_halfs = splited.inject([]) do |acc, split|
      palindrome_halfs = split.permutation.to_a.uniq.select do |palindrome_half|
        tmp = palindrome_half.dup
        tmp << tmp[-1] if tmp.length.odd? 
        # dlog({:tmp => tmp})
        if (palindrome_half.length > 1 && palindrome_half[-1] == palindrome_half[-2]) || \
          tmp.select.with_index{|v, i| i.odd?}.each_cons(2).inject(false){|acc, (p, n)| acc || (p == n)} || \
          tmp.select.with_index{|v, i| i.even?}.each_cons(2).inject(false){|acc, (p, n)| acc || (p == n)}
          false
        else
          true
        end
      end
      # dlog({:palindrome_halfs => palindrome_halfs})
      acc.concat(palindrome_halfs)
      acc
    end
    dlog({:valid_palindrome_halfs => valid_palindrome_halfs})
    valid_palindrome_halfs.map do |palindrome| 
      half = palindrome.map{|num| num.to_s}
      half + half.reverse
    end
  end

  def solve
    dlog({:n => @n, :min => 10 ** (@n-1), :max => 10 ** @n})
    answer = 0
    length = 1

    min = 0
    while min && min < 10 ** @n
      palindromes = make_palindromes(length, @n)
      numbers = perse(palindromes)
      dlog({:length => length, :palindromes => palindromes, :numbers => numbers})
      min = numbers.min
      numbers = filter(numbers)
      dlog({:filtered_numbers => numbers})
      length += 1
      answer += numbers.length
      # sleep(2)
    end
    answer
  end
end

n = STDIN.gets.chomp.to_i
solver = Solver.new(n)
puts solver.solve