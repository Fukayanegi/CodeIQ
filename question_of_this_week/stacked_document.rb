require 'set'

def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Solver
  attr_reader :target, :stack, :queue, :approved, :approved_ptrn
  def initialize m, n
    @m = m
    @n = n
    @target = n
    @stack = []
    @queue = (1..m).to_a
    @approved = []
    @approved_ptrn = Set.new
  end

  def approve
    tmp = stack.pop
    approved << tmp

    if tmp == target
      approved_ptrn << approved.dup
    else
      process_next
    end

    stack << tmp
    approved.pop
  end

  def document
    tmp = queue.shift
    stack << tmp
    process_next
    queue.unshift(tmp)
    stack.pop
  end

  def process_next
    # dlog({:queue => queue, :stack => stack, :approved => approved})
    if stack.length == 0
      document
    elsif queue.length == 0
      approve
    else
      document
      approve
    end
  end

  def solve
    process_next
    approved_ptrn.length
  end
end

m, n = STDIN.gets.chomp.split(" ").map(&:to_i)
# m, n = 3, 2
# m, n = 13, 12
dlog({:m => m, :n => n})

solver = Solver.new(m, n)
puts solver.solve