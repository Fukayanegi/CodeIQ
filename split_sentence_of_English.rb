document = STDIN.gets

matches = document.scan(/.*?\D+?.*?(?<!Mr)(?<!Ms)(?<!Mrs)(?<!Mt)(?:\.+|\?+|\!+|\.+)(?: |\Z)/)

matches.each do |md|
  puts md
end
