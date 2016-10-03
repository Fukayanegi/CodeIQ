class Fixnum
  def twice
    return 2 * self
  end

  def half_of
    return self / 2
  end
end

class Calculator
  @@expressions = {/(add) (?<operand1>.*) (to) (?<operand2>.*)/ => :+,
    /(?<operand2>.*) (added) (to) (?<operand1>.*)/ => :+,
    /(?<operand1>.*) (plus) (?<operand2>.*)/ => :+,
    /(substract) (?<operand2>.*) (from) (?<operand1>.*)/ => :-,
    /(?<operand1>.*) (minus) (?<operand2>.*)/ => :-,
    /(?<operand1>.*) (times) (?<operand2>.*)/ => :*,
    /(?<operand1>.*) (multiplied) (by) (?<operand2>.*)/ => :*,
    /(twice) (?<operand1>.*)/ => :twice,
    /(divide) (?<operand1>.*) (by) (?<operand2>.*)/ => :/,
    /(?<operand2>.*) (divides) (?<operand1>.*)/ => :/,
    /(half) (of) (?<operand1>.*)/ => :half_of
  }
  @@numbers = {:zero => 0, :one => 1, :two => 2, :three => 3, :four => 4, :five => 5, 
    :six => 6, :seven => 7, :eight => 8, :nine => 9, :ten => 10, 
    :eleven => 11, :twelve => 12, :thirteen => 13, :fourteen => 14, :fifteen => 15,
    :sixteen => 16, :seventeen => 17, :eighteen => 18, :nineteen => 19,
    :twenty => 20, :thirty => 30, :forty => 40, :fifty => 50, 
    :sixty => 60, :seventy => 70, :eighty => 80, :ninety => 90}
  @@modifable_numbers = {:hundred => 100, :thousand => 1000, :million => 1000000}
  attr_accessor :m

  def initialize
  end

  def parse_num str
    tmp = /(?<num1>.*) (and) (?<num2>.*)/.match(str)
    answer = 0
    if tmp.nil?
      answer = str.split(" ").inject(0) do |acc, v|
        s = v.to_sym
        if @@modifable_numbers.include? s
          acc *= @@modifable_numbers[s]
        else
          acc += @@numbers[s]
        end
        acc
      end
    else
      answer = parse_num tmp[:num1]
      answer += parse_num tmp[:num2]
    end
    answer
  end

  def calclate statement
    answer = 0
    @@expressions.each do |expression, operator|
      if tmp = expression.match(statement)
        operands = []
        tmp.names.sort.each{|operand| operands << (parse_num tmp[operand])}
        first = operands.shift
        if operands.length > 0
          answer = first.send(operator, *operands)
        else
          answer = first.send operator
        end
      end
    end
    answer
  end
end

statement = STDIN.gets.chomp
calculator = Calculator.new
puts calculator.calclate statement