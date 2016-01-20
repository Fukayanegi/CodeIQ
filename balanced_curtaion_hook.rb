@runner,@hook = STDIN.gets.chomp.split(',').map{|value| value.to_i}

@runner = @runner - 2
@hook = @hook - 2

@memo = Hash.new

def solve runner, hook, previous

  return 0 if hook > runner

  key = "#{runner}:#{hook}:#{previous}"

  if runner == hook
    return 1
  elsif runner / 2 > hook
    return 0
  elsif hook == 0
    return 1
  end

  # p @memo[key] if @memo.include? key
  return @memo[key] if @memo.include? key

  if previous == 0
    @memo[key] = solve runner-1, hook-1, 1
    return @memo[key]
  else
    on = solve runner-1, hook-1, 1
    off = solve runner-1, hook, 0
    @memo[key] = on + off
    return @memo[key]
  end
end

puts solve @runner, @hook, 1