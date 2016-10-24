class Hex
  @@neighbor_pos = [:LEFT_ABOVE, :RIGHT_AVOVE, :LEFT, :RIGHT, :LEFT_BENEATH, :RIGHT_BENEATH]

  class Cell
    include Comparable
    attr_accessor :value, :longest_path
    def initialize char
      @value = char.ord
      @longest_path = 1
      @neighbors = []
    end

    def to_str
      value.chr
    end

    def <=> other
      @value - other.value
    end

    def add_neighbor neighbor
      @neighbors << neighbor
    end

    def notify
      @neighbors.each do |neighbor|
        if (self > neighbor)
          neighbor.update_longest_path!(longest_path) 
        end
      end
    end

    def update_longest_path! neighbor_longest_path
      if longest_path < 1 + neighbor_longest_path
        self.longest_path = 1 + neighbor_longest_path 
        notify
      end
    end
  end

  attr_accessor :hex
  def initialize str
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

    def set_observers! hex
      hex.each_with_index do |line, row|
        line.each_with_index do |cell, col| 
          @@neighbor_pos.each do |pos|
            n_row, n_col = neighbor_index(row, col, pos)
            if n_row >= 0 && n_row < hex.length && n_col >= 0 && n_col < hex[n_row].length
              neighbor = hex[n_row][n_col]
              cell.add_neighbor(neighbor)
            end
          end
        end
      end
    end

    @hex = []
    str.split("/").each_with_index do |line, row|
      h_line = []
      line.each_char.each_with_index do |c, col|
        h_line << Cell.new(c)
      end
      @hex << h_line
    end

    set_observers!(hex)
  end

  def show
    hex.each_with_index do |line, i|
      line_array = block_given? ? (yield line) : line
      p " " * (i - 3).abs + line_array.join(" ") + " " * (i - 3).abs
    end
  end

  def show_value
    show{|line| line.map{|cell| "%02d" % (cell.value - 'a'.ord)}}
  end

  def show_longest_path
    show{|line| line.map{|cell| cell.longest_path}}
  end

  def search_longest_path
    hex.each do |line|
      line.each do |cell|
        cell.notify
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
end

input = STDIN.gets.chomp
hex = Hex.new(input)
hex.search_longest_path
puts hex.longest_path
