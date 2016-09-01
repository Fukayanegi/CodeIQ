def factorial n
  return 1 if n < 1
  (1..n).to_a.inject{|acc, v| acc * v}
end

def combination n, r
  permutation(n,r) / factorial(r)
end

def permutation n, r
  factorial(n) / factorial(n - r)
end

def build_courses courses, total_pat, min_pat
  # p "call build_courses: courses = #{courses}, total_pat = #{total_pat}, min_pat = #{min_pat}"
  if courses == 1
    # p "courses = #{courses}, total_pat = #{total_pat}"
    return [[total_pat]] if (total_pat > 0 && total_pat <= 5 && total_pat >= min_pat)
    return [[]] if (total_pat <= 0 || total_pat > 5 || total_pat < min_pat)
  end

  answer = []
  (min_pat..5).each do |par|
    # p "par = #{par}"
    total_pat -= par
    courses -= 1
    tmp = build_courses courses, total_pat, par
    if tmp != [[]]
      tmp.each do |course|
        answer << (course.unshift par)
      end
    end
    courses += 1
    total_pat += par
  end

  answer
end

m, n = STDIN.gets.chomp.split(" ").map{|v| v.to_i}
# p "m = #{m}, n = #{n}"

courses = build_courses m, n, 1
patterns = 0

courses.each do |course|
  course_h = course.inject({}) do |acc, v|
    acc[v] = 0 if !acc.include? v
    acc[v] += 1
    acc
  end

  comb = course_h.select{|k, v| v > 1}.inject(1){|acc, (k, v)| acc *= permutation(v, v); acc}
  patterns += factorial(m) / comb
  # p "course = #{course}, course_h = #{course_h}, comb = #{comb}"
end

puts patterns

