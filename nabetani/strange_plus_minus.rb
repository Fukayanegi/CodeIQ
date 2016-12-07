
class Solver
  OPERATORS = {:plus => "+", :minus => "-"}
  def initialize expression
    @expression = expression
  end

  def calculate numbers, operators
    num1 = numbers.pop
    while ((num2 = numbers.pop) != nil)
      operator = operators.pop
      num1 = num2.send(operator.to_sym, num1)
    end
    num1
  end

  def solve_inner expression
    stack_num = []
    stack_ope = []
    num_buf = 0

    while ((c = expression.shift) != nil)
      break if c == ")"
      if c == "("
        num_buf = solve_inner(expression)
      elsif Solver::OPERATORS.values.any?{|v| v == c}
        stack_num << num_buf
        num_buf = 0
        stack_ope << c
      else
        num_buf = (num_buf * 10) + c.to_i
      end
    end
    stack_num << num_buf

    calculate(stack_num, stack_ope)
  end

  def solve
    solve_inner(@expression.dup.each_char.to_a)
  end
end

expression = STDIN.gets.chomp
# 19+2-3-4
# 2-(2-2)-2
solver = Solver.new(expression)
puts solver.solve