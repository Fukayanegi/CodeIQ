require 'csv'

def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Converter
  CONV = Hash.new{|hash, key| key}
  CONV.merge!({"&" => "&amp;", "<" => "&lt;", ">" => "&gt;"})

  def self.table_data input
    tmp = input.map.with_index do |row, i|
      if i == 0
        trim_quoute(CSV.parse(row)[0]){|elements| sanitize(elements){|s_elem| th(s_elem){|th| tr([th]){|tr| tr}}}}
      else
        trim_quoute(CSV.parse(row)[0]){|elements| sanitize(elements){|s_elem| td(s_elem){|td| tr([td]){|tr| tr}}}}
      end
    end.join
    yield tmp
  end

  def self.th input
    yield input.map{|elem| "<th>#{elem}</th>"}.join
  end

  def self.tr input
    yield input.map{|elem| "<tr>#{elem}</tr>"}.join
  end

  def self.td input
    yield input.map{|elem| "<td>#{elem}</td>"}.join
  end

  def self.trim_quoute input
    yield input.map{|elem| elem.gsub(/\"(.*)\"/, "\\1")}
  end

  def self.sanitize input
    yield input.map{|elem| Converter::CONV.inject(elem){|acc, (key, value)| acc.gsub!(key, value); acc}}
  end

  def self.convert input
    table_data(input){|table_data| "<table>#{table_data}</table>"}
  end
end

input = []
while line = STDIN.gets do
# while line = DATA.gets do
  input << line.chomp
end
puts Converter.convert(input)

__END__
"x","y"
1,2
&,<
",a"a