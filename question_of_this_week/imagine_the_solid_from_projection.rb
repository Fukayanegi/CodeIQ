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
  line.scan(/(\[([10,]*)\])/).each do |match|
    projection << match[1].split(",")
  end
end
projection.each{|plane| dlog({:plane => plane})}