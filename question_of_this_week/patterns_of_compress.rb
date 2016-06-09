@m, @n = STDIN.gets.chomp.split(",").map{|num| num.to_i}
# p "#{@m}, #{@n}"

@res = 0
def solve score, letters, rest
  @res += 1 if score < 0 && rest == 0
  # p "#{letters}, #{score}" if rest == 0
  return if rest == 0

  score_mem = score
  (1..@m).each do |letter|
    score = score_mem
    c = (96+letter).chr
    prv = letters[-1] || ""
    # p "#{rest}, #{c}"
    score += 1 if prv != c
    score -= 1 if prv == c
    letters << c
    solve score, letters, rest - 1
    letters.slice! -1
  end
end

solve 0, [], @n
puts @res