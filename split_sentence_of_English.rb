document = STDIN.gets

buf = ""
escape = false
document.each_char do |c|
  buf << c
  escape = !escape if (c == "\"")
  if !escape && (c == "." || c == "?")
    puts buf.strip
    buf = ""
  end
end