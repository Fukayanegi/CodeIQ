target = STDIN.gets.chomp.to_i
menu = []
while line = STDIN.gets do
  menu << line.chomp.to_i
end

# p "#{target}"
# p "#{menu.sort}"

class Solver
  def initialize target
    @target = target
  end

  def replace_to replace_from, num_of_replace, selected, menu, diff
    replace_from_sum = replace_from.inject(:+)
    delta_min = 0
    delta_min_prev = delta_min
    for m in num_of_replace.to_a
      menu.combination(m) do |replace_to|
        replace_to_sum = replace_to.inject(:+)
        delta = diff > 0 ? replace_to_sum - replace_from_sum : replace_from_sum - replace_to_sum
        delta_min = delta if (delta < delta_min && delta > 0)
        if delta > 0 && delta < diff.abs * 2
          replace_from.each{|val|selected.delete val}
          replace_to.each{|val|menu.delete val}
          selected.concat replace_to
          menu.concat replace_from
          diff = @target - selected.inject(:+)

          return diff
        end
      end
      
      return diff if (delta_min == delta_min_prev && delta_min > 0)
    end

    return diff
  end

  def replace selected, menu, diff_previous
    diff = diff_previous
    1.upto(selected.length).each do |n|
      selected.combination(n) do |replace_from|
        num_of_replace = diff_previous > 0 ? (n.downto 1) : (1.upto n)

        diff = replace_to replace_from, num_of_replace, selected, menu, diff_previous
        return diff if diff.abs < diff_previous.abs
      end
    end

    return diff
  end

  def solve menu
    tmp = 0
    selected = []
    next_order = menu[0]
    while tmp + next_order < @target
      selected << menu.shift
      tmp += next_order
      next_order = menu[0]
    end

    # p "#{selected}"
    # p "#{tmp}"

    previous_diff = @target
    diff = @target - tmp
    while diff.abs < previous_diff.abs
      previous_diff = diff
      diff = replace selected, menu, diff
    end

    diff.abs
  end
end

solver = Solver.new target
answer = solver.solve menu.sort

p answer