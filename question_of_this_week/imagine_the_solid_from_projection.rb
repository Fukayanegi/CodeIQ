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

projection = []
while line = STDIN.gets
  projection << line.scan(/(\[([10,]*)\])/).map{|m| m[1].split(",")}
end
projection.each{|plane| dlog({:plane => plane})}

h, d, w = 3, 3, 3
solid = Array.new(h){|z| Array.new(d){|y| Array.new(w){|x| 1}}}
dlog({:solid => solid})