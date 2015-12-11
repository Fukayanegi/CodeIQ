# Nが偶数のとき、N回反転してもZからしか出られないため、N-1のPと同じとなる
#️ 以下、Nは奇数の前提
# NとN-2とのPの差はN-2回反転してYから出るパターンの数をベースとして
#  1. N-2回目の反転をBでした場合 * 2 + N-2回目の反転をCでした場合 * 3 だけ増える
#   1-B. Bで反転してあと2回反転できる場合：Aで反転->Bで反転、Aで反転->Cで反転の2パターンが取れるため
#   1-C. Cで反転してあと2回反転できる場合：Aで反転->Bで反転、Aで反転->Cで反転、Bで反転->Cで反転の3パターンが取れるため
#  2. またこのときN回目の反転のパターンは下記となる
#   2-B. Bの場合：N-2回目の反転をBでした場合 * 1 + N-2回目の反転をCでした場合 * 1
#   2-C. Cの場合：N-2回目の反転をBでした場合 * 1 + N-2回目の反転をCでした場合 * 2
# N回反転できる場合、[N-2のP]+[1-B]+[1-C]となる
# [1-B]、[1-C]を計算するために[2-B][2-C]が必要となる

def solve lor
  # check input
  if lor < 0 then
#    puts "Warning : N must be over 0"
    return { b: 0, c: 0, x: 0 }
  else
    if lor % 1 != 0
#      puts "Warning : N should be Integer. Truncate #{lor} to #{lor.floor}"
    end

    lor = lor.to_i
    return { b: 0, c: 0, x: 0 } if lor < 1
    return { b: 1, c: 1, x: 0 } if lor <= 2
  end

  # do with recursive call
  if lor > 2 then
    lor = lor - 1 if lor.even?
    answer_tmp = solve lor - 2
    new_b = answer_tmp[:b] * 1 + answer_tmp[:c] * 1 
    new_c = answer_tmp[:b] * 1 + answer_tmp[:c] * 2
    return { b: new_b, c: new_c, x: answer_tmp[:b] + answer_tmp[:c] + answer_tmp[:x] }
  end
end

n = STDIN.gets
if n.nil?
#  puts "Warning N must not be nil"
  exit 0
end

#puts "INPUT : N = " + n
begin
  lmt_of_rtn = Float(n)
rescue
#  puts "Warning : N is not a number"
  lmt_of_rtn = 0
end

answer_tmp = solve lmt_of_rtn
answer = answer_tmp.values.inject(:+)

#puts "OUTPUT : P = " + answer.to_s

puts answer

# 挑戦完了