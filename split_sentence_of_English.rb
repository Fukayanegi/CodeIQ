document = STDIN.gets
regex = Regexp.new(".*?\\D+?.*?(?<!Mr)(?<!Ms)(?<!Mrs)(?<!Mt)(?:\\.+|\\?+|\\!+|\\.+)(?: |\\Z)")

matches = document.scan(regex)

matches.each do |md|
  puts md
end
