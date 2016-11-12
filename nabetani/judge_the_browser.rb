# コマンドライン引数に"-dlog"があった場合にログを出力する関数
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

user_agent = STDIN.gets.chomp
dlog({:user_agent => user_agent})

answer = case user_agent
when /Mamella\/5.0 \(.*\) Lizard\/\d{8} Firedog\/[\d.]+/
  "MFD"
when /Mamella\/5.0 \(.*\) OrangeKit\/.*\(like Lizard\) Version\/[\d.]+ Voyage\/[\d.]+/
  "VYG"
when /Mamella\/4.0 \(compatible; ASIT [\d.]+; .*\)/, \
  /Mamella\/5.0 \(compatible; ASIT [\d.]+; .*\)/, \
  /Mamella\/5.0 \(.*; Quadent\/7.0; .KNOT SLR; rv:4.0\) like Lizard/, \
  /Mamella\/5.0 \(.*; Quadent\/7.0\) OrangeKit\/12.0 Firedog\/3.0 \(like Lizard\) Voyage\/4.0 ASIT\/12.0/
  "ASIT"
when /Mamella\/4.0 \(.*\) Kabuki [\d.]+/,
  /Mamella\/4.0 \(compatible; ASIT 6.0; ASIT 5.5; .*\) Kabuki [\d.]+/,
  /Kabuki\/\d+.\d+ \(.*\) Lento\/[\d.]+/,
  /Mamella\/5.0 \(.*\) OrangeKit\/[\d.]+ \(like Lizard\) Monochrome\/[d.]+ Voyage\/[d.]+ KBK\/[\d.]+/
  "KBK"
when /Mamella\/5.0 \(.*\) OrangeKit\/[\d.]+ \(like Lizard\) Monochrome\/[\d.]+ Voyage\/[\d.]+/,
  /Mamella\/5.0 \(.*\) OrangeKit\/[\d.]+ \(like Lizard\) Monochrome\/[\d.]+ Voyage\/[\d.]+/
  "GMC"
else
  "ELS"
end

puts answer
