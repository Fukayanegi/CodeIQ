class Hex
  class Cell
    include Comparable
    attr_accessor :value, :longest_path
    def initialize char
      @value = char.ord
      @longest_path = 1
    end

    def to_str
      value.chr
    end

    def <=> other
      @value - other.value
    end

    def recieve_signal neighbor_longest_path
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
    @hex = str.split("/").map{|line| line.each_char.map{|c| Cell.new(c)}}
  end

  def show
    hex.each_with_index do |line, i|
      p " " * (i - 3).abs + line.join(" ") + " " * (i - 3).abs
    end
  end

  def show_longest_path
    hex.each_with_index do |line, i|
      p " " * (i - 3).abs + line.map{|cell| cell.longest_path}.join(" ") + " " * (i - 3).abs
    end
  end

  def cell row, col
    if row >= 0 && row < hex.length && col >= 0 && col < hex[row].length
      hex[row][col]
    else
      nil
    end
  end

  def solve
    hex.each_with_index do |row, i|
      row.each_with_index do |col , j|
        join(i, j)
      end
    end
  end

  def join row, col
    base = cell(row, col)
    (tmp = cell(row-1, col-1)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row-1, col-1))
    (tmp = cell(row-1, col)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row-1, col))
    (tmp = cell(row, col-1)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row, col-1))
    (tmp = cell(row, col+1)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row, col+1))
    (tmp = cell(row+1, col)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row+1, col))
    (tmp = cell(row+1, col+1)) && (base > tmp && tmp.recieve_signal(base.longest_path) && join(row+1, col+1))
  end
end

input = STDIN.gets.chomp
hex = Hex.new(input)
hex.show
puts
hex.show_longest_path
puts
hex.solve
puts
hex.show_longest_path