A = [[1]]
B = [[1, 1], [1, 1]]
C = [[1, 1, 1, 1], [1, 1, 1, 1]]
D = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]

def solve width, height
  patterns = solve_patterns width * height, [{A:0, B:0, C:0, D:0}], [:D, :C, :B, :A]
  patterns.uniq
end

def solve_patterns size, use, choice
  first_choice = choice[0]
  use_dup = use[use.size-1].dup
  tile = eval(first_choice.to_s)
  t_size = tile.inject(0) {|sum, array| sum += array.inject(:+)}
#  puts "#{size}, #{t_size}, #{tile}"

  if size >= t_size
    use[use.size-1][first_choice] += 1
    solve_patterns size - t_size, use, choice.dup
  end

  choice.shift
  if choice.length > 0 then
    use << use_dup
    solve_patterns size, use, choice
  end
  
  use
end

size = STDIN.gets
if size.nil?
  puts "Warning size must not be nil"
  exit 0
end

width, height = size.split(',')
puts "INPUT : Width = #{width}, Height = #{height}"
begin
  width, height = Integer(width), Integer(height)
rescue
  puts "Warning : Width or Height is not a number"
  width, height = 0, 0
end

answer_tmp = solve width, height
answer = answer_tmp.count

p answer_tmp
puts "OUTPUT : Patterns = " + answer.to_s

puts answer
