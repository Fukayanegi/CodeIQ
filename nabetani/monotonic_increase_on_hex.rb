class Hex
  @@neighbor_pos = [:LEFT_ABOVE, :RIGHT_AVOVE, :LEFT, :RIGHT, :LEFT_BENEATH, :RIGHT_BENEATH]

  class Cell
    include Comparable
    attr_accessor :row, :col, :value, :longest_path
    def initialize row, col, char
      @row = row
      @col = col
      @value = char.ord
      @longest_path = 1
    end

    def to_str
      value.chr
    end

    def <=> other
      @value - other.value
    end

    def update_longest_path neighbor_longest_path
      if longest_path < 1 + neighbor_longest_path
        self.longest_path = 1 + neighbor_longest_path 
        true
      else
        false
      end
    end
  end

  attr_accessor :hex
  def initialize str
    @hex = []
    str.split("/").each_with_index do |line, row|
      h_line = []
      line.each_char.each_with_index do |c, col|
        h_line << Cell.new(row, col, c)
      end
      hex << h_line
    end
  end

  def show
    show_inner{|line| line}
  end

  def show_value
    show_inner{|line| line.map{|cell| "%02d" % (cell.value - 'a'.ord)}}
  end

  def show_longest_path
    show_inner{|line| line.map{|cell| cell.longest_path}}
  end

  def search_longest_path
    hex.each_with_index do |line, row|
      line.each_with_index do |cell , col|
        notify(row, col)
      end
    end
  end

  def longest_path
    hex.inject(0) do |acc, line|
      line.inject(acc) do |acc_sub, cell| 
        acc_sub = acc_sub < cell.longest_path ? cell.longest_path : acc_sub
      end
    end
  end

  private
  def show_inner
    hex.each_with_index do |line, i|
      tmp = yield line
      p " " * (i - 3).abs + tmp.join(" ") + " " * (i - 3).abs
    end
  end

  def cell row, col
    if row >= 0 && row < hex.length && col >= 0 && col < hex[row].length
      hex[row][col]
    else
      nil
    end
  end

  def neighbor_index base_row, base_col, pos
    row = base_row
    col = base_col
    case pos
    when :LEFT_ABOVE then
      row -= 1
      col -= 1 if base_row <= 3
    when :RIGHT_AVOVE then
      row -= 1
      col += 1 if base_row > 3
    when :LEFT then
      col -= 1
    when :RIGHT then
      col += 1
    when :LEFT_BENEATH then
      row += 1
      col -= 1 if base_row >= 3
    when :RIGHT_BENEATH then
      row += 1
      col += 1 if base_row < 3
    end
    [row, col]
  end

  def notify row, col
    base = cell(row, col)
    @@neighbor_pos.each do |pos|
      n_row, n_col = neighbor_index(row, col, pos)
      neighbor = cell(n_row, n_col)
      if !neighbor.nil?
        (base > neighbor) && neighbor.update_longest_path(base.longest_path) && notify(n_row, n_col)
      end
    end
  end
end

input = STDIN.gets.chomp
hex = Hex.new(input)
# hex.show
# puts
# hex.show_value
# puts
hex.search_longest_path
# hex.show_value
# puts
puts hex.longest_path
