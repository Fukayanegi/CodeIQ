@w,@h = STDIN.gets.chomp.split(',')
@w,@h = @w.to_i,@h.to_i
pass = []
# p "#{@w}, #{@h}"

def solve pass, from, to

  r_f,c_f = from.split(',')
  r_t,c_t = to.split(',')
  next_root = r_f < r_t || c_f < c_t ? from + "@" + to : to + "@" + from

  pass << next_root

  if next_root == "0,0@0,1"
    # p pass
    return pass.count
  end

  n_a = to + "@" + (r_t.to_i+1).to_s + "," + c_t # down
  n_b = to + "@" + r_t + "," + (c_t.to_i+1).to_s # right
  n_c = r_t + "," + (c_t.to_i-1).to_s + "@" + to # left
  n_d = (r_t.to_i-1).to_s + "," + c_t + "@" + to # up

  # p "#{r_t}, #{c_t}, #{n_a}"
  # p "#{r_t}, #{c_t}, #{n_b}"
  # p "#{r_t}, #{c_t}, #{n_c}" if n_c == "0,0@0,1"
  # p "#{r_t}, #{c_t}, #{n_d}" if n_d == "0,1@1,1"

  # p r.to_i < @h && !pass.include?(n_a)
  # p c.to_i < @w && !pass.include?(n_b)
  # p c.to_i > 0 && !pass.include?(n_c)
  # p r.to_i > 0 && !pass.include?(n_d)

  a = (r_t.to_i < @h && !pass.include?(n_a)) ? solve(Marshal.load(Marshal.dump(pass)), to, (r_t.to_i+1).to_s + "," + c_t) : 0
  b = (c_t.to_i < @w && !pass.include?(n_b)) ? solve(Marshal.load(Marshal.dump(pass)), to, r_t + "," + (c_t.to_i+1).to_s) : 0
  c = (c_t.to_i > 0 && !pass.include?(n_c)) ? solve(Marshal.load(Marshal.dump(pass)), to, r_t + "," + (c_t.to_i-1).to_s) : 0
  d = (r_t.to_i > 0 && !pass.include?(n_d)) ? solve(Marshal.load(Marshal.dump(pass)), to, (r_t.to_i-1).to_s + "," + c_t) : 0

  # p a
  # p b
  # p c
  # p d

  answer = [a,b,c,d]
  # p answer
  return answer.max
end

answer = solve [], "0,0", "1,0"
p answer