m, n = STDIN.gets.chomp!.split(",").map{|value| value.to_i}

# オイラー路の定義より、m*nのセルに1本線を引くだけで次数が奇数である頂点が2つとなり、
# それ以上引くと必ず次数が奇数である頂点が2増えることになる
# 縦に1本引けるケース+横に1本引けるケース+m*nの長方形️
# 参考：https://ja.wikipedia.org/wiki/オイラー路
p m - 1 + n - 1 + 1

# p "#{m}, #{n}"