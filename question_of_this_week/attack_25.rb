class Solver
  attr_accessor :colored_panles

  def initialize
    @panels = Array.new(7) {Array.new(7) {0}}
    @candidate_panels = (1..25).to_a
    @colored_panles = Hash.new
  end

  def adjacent_put_panel? i, j
    return false if @panels[i][j] != 0
    return true if @panels[i - 1][j - 1] > 0
    return true if @panels[i - 1][j] > 0
    return true if @panels[i - 1][j + 1] > 0
    return true if @panels[i][j - 1] > 0
    return true if @panels[i][j + 1] > 0
    return true if @panels[i + 1][j - 1] > 0
    return true if @panels[i + 1][j] > 0
    return true if @panels[i + 1][j + 1] > 0
    false
  end

  def search_candidate_panels 
    candidate = []
    @panels.each_with_index do |row, i|
      row.each_with_index do |col, j|
        candidate << ((i - 1) * 5 + j) if adjacent_put_panel? i, j
        # p "#{i}, #{j}, #{adjacent_put_panel? i, j, panel}"
      end
    end
    candidate.length > 0 ? candidate : [13]
  end

  def initialize_panel
    @panels.each_with_index do |row, i|
      if i == 0 || i == 6
        row.each_with_index do |col, j|
          row[j] = -1
        end
      end
      row[0] = -1
      row[6] = -1
    end

    @colored_panles.each do |key, values|
      values.each do |value|
        row = (value - 1) / 5 + 1
        col = value % 5 == 0 ? 5 : value % 5
        @panels[row][col] = key.ord
      end
    end

    @candidate_panels = search_candidate_panels
  end

  def can_hold_between? color, row, col, horizonal, vertical, exclude = color
    meet_other_color = false
    ret_val = false
    while @panels[row + horizonal][col + vertical] >= 0 do
      return meet_other_color if @panels[row + horizonal][col + vertical] == color.ord
      if @panels[row + horizonal][col + vertical] > 0 && @panels[row + horizonal][col + vertical] != exclude.ord
        meet_other_color = true
        row, col = row + horizonal, col + vertical
      else
        break
      end
    end
    ret_val
  end

  def puttable_panels color, exclude = color
    answer = []
    @candidate_panels.each do |panel|
      row = (panel - 1) / 5 + 1
      col = panel % 5 == 0 ? 5 : panel % 5
      can_hold_between = false
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, -1, -1, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, 0, -1, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, 1, -1, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, -1, 0, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, 1, 0, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, -1, 1, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, 0, 1, exclude)
      can_hold_between = can_hold_between || can_hold_between?(color, row, col, 1, 1, exclude)
      answer << panel if can_hold_between
    end

    answer = puttable_panels 0, color if answer.length == 0 && color != 0
    answer = @candidate_panels if answer.length == 0

    answer
  end

  def display_panel
    @panels.each do |line|
      # p "%02d, %02d, %02d, %02d, %02d, %02d, %02d" % line
    end
  end

  def solve
    # p "candidate >> #{@candidate_panels}"
    @colored_panles.each do |color, keep|
      puts "#{color},#{(puttable_panels color).join(",")}"
    end
  end
end

solver = Solver.new
while line = STDIN.gets do
  tmp = line.chomp.split(",")
  solver.colored_panles[tmp[0]] = tmp[1..-1].map{|val| val.to_i}
end

solver.initialize_panel
solver.display_panel
solver.solve
