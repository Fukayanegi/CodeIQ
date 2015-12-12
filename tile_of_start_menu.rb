def solve
  [{A:0, B:0, C:0, D:0}]
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

answer_tmp = solve
answer = answer_tmp.count

puts "OUTPUT : Patterns = " + answer.to_s

puts answer
