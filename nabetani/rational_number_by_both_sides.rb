target = Rational(*STDIN.gets.chomp.split("/").map{|v| v.to_i})
# p "target: #{target}"

def is_left_child? rational
  return rational.denominator - rational.numerator > rational.numerator
end

def parent_rational rational
  if is_left_child?(rational)
    Rational(rational.numerator, rational.denominator - rational.numerator)
  else
    Rational(rational.denominator - rational.numerator, rational.denominator)
  end
end

def left_child rational
  # p "#{rational}'s left child: #{Rational(rational.numerator, rational.numerator + rational.denominator)}"
  Rational(rational.numerator, rational.numerator + rational.denominator)
end

def right_child rational
  return nil if rational.numerator * 2 >= rational.denominator
  # p "#{rational}'s right child: #{Rational(rational.denominator - rational.numerator, rational.denominator)}"
  Rational(rational.denominator - rational.numerator, rational.denominator)
end

def left rational
  return nil if rational.numerator == 1

  parent = parent_rational(rational)
  # p "#{rational}'s parent: #{parent}"
  if is_left_child?(rational)
    # p "#{rational}' is left_child"
    parent_left = left(parent)
    if parent_left.nil?
      ancestor = parent_rational(parent)
      ancestor_left = left(ancestor)
      parent_left = left_child(ansestor_left)
    end
    tmp = right_child(parent_left) || left_child(parent_left)
    # p "#{rational}'s left; #{tmp}"
    tmp
  else
    # p "#{rational}' is right_child"
    tmp = left_child(parent)
    # p "#{rational}'s left; #{tmp}"
    tmp
  end
end

def right rational
  return nil if rational.denominator <= 3

  parent = parent_rational(rational)
  # p "#{rational}'s parent: #{parent}"
  parent_right = right(parent)

  if is_left_child?(rational)
    # p "#{rational}' is left_child"
    tmp = right_child(parent) || (parent_right.nil? ? nil : left_child(parent_right))
    # p "#{rational}'s right; #{tmp}"
    tmp
  else
    # p "#{rational}' is right_child"
    if parent_right.nil?
      ansestor = parent_rational(parent)
      ansestor_right = right(ansestor)
      parent_right = ansestor_right.nil? ? nil : left_child(ansestor_right)
    end
    tmp = parent_right.nil? ? nil : left_child(parent_right)
    # p "#{rational}'s right; #{tmp}"
    tmp
  end
end

# p left(target)
# p right(target)
puts "%s,%s" % [left(target) || "-", right(target) || "-"]