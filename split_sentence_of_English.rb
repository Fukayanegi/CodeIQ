document = STDIN.gets
keyword_end_before = ["\\.", "\\?", "\\!"]
keyword_end = [" ", "\\Z"]
keyword_not_end = ["Mr", "Ms", "Mrs", "Mt"]

str_keb = "(?:" + keyword_end_before.map {|keyword| "#{keyword}+" }.join("|") + ")"
str_ke = "(?:" + keyword_end.map {|keyword| "#{keyword}" }.join("|") + ")"
str_ne = keyword_not_end.map {|keyword| "(?<!#{keyword})" }.join 

regex = Regexp.new(".*?\\D+?.*?" + str_ne + str_keb + str_ke)

matches = document.scan(regex)

matches.each do |md|
  puts md
end
