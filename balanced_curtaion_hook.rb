@runner,@hook = STDIN.gets.chomp.split(',').map{|value| value.to_i}

@runner = @runner - 2
@hook = @hook - 2

def solve runner, hook, previous
  if runner == hook
    return 1
  elsif runner / 2 > hook
    return 0
  end

  if previous == 0
    return solve runner-1, hook-1, 1
  else
    hook = solve runner-1, hook-1, 1
    unhook = solve runner-1, hook, 0
    return hook + unhook
  end
end

puts solve @runner, @hook, 1