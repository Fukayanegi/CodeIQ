# コマンドライン引数に"-debug"があった場合にログを出力する関数
def dlog variables, method = ""
  # TODO: 何かもっとエレガントな方法で
  if ARGV[0] == "-debug"
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

n = STDIN.gets.chomp.to_i
dlog({:n => n})

def count_up_dist dist, offsets
  dist_tmp = {}
  return dist_tmp if offsets == []

  dist.each do |key, value|
    offsets.each do |offset|
      target = key + offset
      dist_tmp[target] = (dist_tmp[target] || 0) + value
    end
  end
  dist_tmp
end

def merge_dist! dist, dist_tmp
  dist_tmp.each do |key, value|
    dist[key] = (dist[key] || 0) + value
  end
  dist
end

def parse_sum_dist number
  if number < 10
    dist = {}
    (0..number).each do |i|
      dist[i] = 1
    end
    return dist
  end

  base = 10 ** Math.log10(number).to_i
  dist = parse_sum_dist(base - 1)

  offset = (number / base) - 1
  dist_tmp = count_up_dist(dist, 1.upto(offset))
  dist = merge_dist!(dist, dist_tmp)

  dist_rest = parse_sum_dist(number % base)
  dist_rest = count_up_dist(dist_rest, [number / base])
  merge_dist!(dist, dist_rest)

  dist
end

def func_f number
  answer = 0
  sum = number
  while sum >= 10
    sum = 0
    (Math.log10(number).to_i).downto(0) do |digit|
      sum += number / (10 ** digit)
      number = number % 10 ** digit
    end
    answer += 1
    number = sum
  end
  answer
end

def func_g number
  # 1..numberに対して各桁の和をとった数の分布
  dist = parse_sum_dist(number)

  # 10以上を対象とする
  # => 9以下は0のため
  dist_sigle = {}
  (0..(number < 10 ? number : 9)).each do |i|
    dist_sigle[i] = -1
  end
  dist = merge_dist!(dist, dist_sigle)

  dlog({:dist => dist})
  # dlog({:dist_sum => dist.select{|(key, value)| key > 0}.values.inject(:+)})
  dist.select{|(key, value)| key > 0}.map{|(key, value)| (func_f(key) + 1) * value}.inject(:+)
end

p func_g(n)