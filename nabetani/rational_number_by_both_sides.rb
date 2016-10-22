numerator, denominator = STDIN.gets.chomp.split("/").map{|v| v.to_i}
# p "numerator: #{numerator}, denominator: #{denominator}"

def is_left_child? numerator, denominator
  return denominator - numerator > numerator
end

def parent numerator, denominator
  if is_left_child?(numerator, denominator)
    Rational(numerator, denominator - numerator)
  else
    Rational(denominator - numerator, denominator)
  end
end

def left numerator, denominator
  return nil if numerator == 1

  pa = parent(numerator, denominator)
  # p "#{numerator}/#{denominator}'s parent: #{pa}"
  if is_left_child?(numerator, denominator)
    pa_le = left(pa.numerator, pa.denominator)
    if pa_le.nil?
      pa_pa = parent(pa.numerator, pa.denominator)
      pa_pa_le = left(pa_pa.numerator, pa_pa.denominator)
      pa_le = left_child(pa_pa_le.numerator, pa_pa_le.denominator)
    end
    right_child(pa_le.numerator, pa_le.denominator)
  else
    left_child(pa.numerator, pa.denominator)
  end
end

def right numerator, denominator
  return nil if numerator == 1 and denominator == 2

  pa = parent(numerator, denominator)
  # p "#{numerator}/#{denominator}'s parent: #{pa}"
  pa_ri = right(pa.numerator, pa.denominator)
  # p "#{pa.numerator}/#{pa.denominator}'s right: #{pa_ri}"

  if is_left_child?(numerator, denominator)
    # p "#{pa.numerator}/#{pa.denominator}'s right_child: #{right_child(pa.numerator, pa.denominator)}"
    right_child(pa.numerator, pa.denominator) || (pa_ri.nil? ? nil : left_child(pa_ri.numerator, pa_ri.denominator))
  else
    if pa_ri.nil?
      pa_pa = parent(pa.numerator, pa.denominator)
      pa_pa_ri = right(pa_pa.numerator, pa_pa.denominator)
      # pa_pa_riはnullable
      pa_ri = pa_pa_ri.nil? ? nil : left_child(pa_pa_ri.numerator, pa_pa_ri.denominator)
    end
    pa_ri.nil? ? nil : left_child(pa_ri.numerator, pa_ri.denominator)
  end
end

def left_child numerator, denominator
  # p "#{numerator}/#{denominator}'s left child: #{Rational(numerator, numerator + denominator)}"
  Rational(numerator, numerator + denominator)
end

def right_child numerator, denominator
  return nil if numerator * 2 >= denominator
  # p "#{numerator}/#{denominator}'s right child: #{Rational(denominator - numerator, denominator)}"
  Rational(denominator - numerator, denominator)
end

# p left(numerator, denominator)
# p right(numerator, denominator)
puts "%s,%s" % [left(numerator, denominator) || "-", right(numerator, denominator) || "-"]