class Solver
  def initialize text
    @text = text
  end

  def solve
    re = /[\-\+]?(0\.|[1-9]+\.?)[0-9]*([e|E]?\-?[1-9]+)(?=\D|$)/
    target = @text.dup
    
    while md = target.match(re) do
      target.gsub!(md[0], "*")
    end
    target
  end
end

text = STDIN.gets.chomp
# text = "x=12 y=-34.5 z=7e-8 a=34.55"
solver = Solver.new(text)
puts solver.solve