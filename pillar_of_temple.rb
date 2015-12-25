require 'set'

@start = "12345678900"
@fin = "02345678910"
# @start = "1234500"
# @fin = "0234510"
@ptn = Set.new

def p_pillar placement
  p "*"*30
  p placement[0..(@p_len / 2 - 1)]
  p placement[@half..(@p_len)]
end

def p_placements placements
  placements.each do |placement|
    p_pillar placement
  end
end

def p_placements2 placements
  placements.each do |placement|
    p placement[0..9]
  end
end

def solve start, fin
  before_placements_from_s = []
  before_placements_from_f = []
  found = false
  count = 0
  @p_len = start[0].length - 1
  @mid_u = (@p_len / 2) / 2
  @mid_b = @mid_u  + @p_len / 2
  @half = @p_len / 2

  # p 'before'
  # p_placements start
  # p_placements fin
  before_placements_from_s = start
  before_placements_from_f = fin

  while !found do
    next_placements_from_s = []
    next_placements_from_f = []

    before_placements_from_s.each do |placement|
      next_placements_from_s.concat (move_all placement)
    end

    target_s = next_placements_from_s.select{|plc| plc[@mid_u] == "0" || plc[@mid_b] == "0"}
    # target_s = next_placements_from_s.select

    target_s.each do |placement1|
      found = found || before_placements_from_f.any? do |placement2|
        # p "#{placement[0..@p_len -1]} #{p[0..@p_len -1]}" if count == 9
        # p_pillar "#{placement1}" if placement1[0..(@p_len -1)] == placement2[0..(@p_len -1)]
        # p_pillar "#{placement2}" if placement1[0..(@p_len -1)] == placement2[0..(@p_len -1)]
        placement1[0..(@p_len -1)] == placement2[0..(@p_len -1)]
      end
    end

    break if found

    before_placements_from_f.each do |placement|
      next_placements_from_f.concat (move_all placement)
    end

    count += 1
    before_placements_from_s = next_placements_from_s
    before_placements_from_f = next_placements_from_f

    # p "#{count}times after"
    # p_placements next_placements_from_s
    # p_placements next_placements_from_f

    # target_s = before_placements_from_s.select{|plc| plc[@mid_u] == "0" || plc[@mid_b] == "0"}
    # target_f = before_placements_from_f.select{|plc| plc[@mid_u] == "0" || plc[@mid_b] == "0"}
    # target_s = before_placements_from_s
    # target_f = before_placements_from_f

    # p_placements target_s
    # p_placements target_f

    # target_s.each do |placement1|
    #   found = found || target_f.any? do |placement2|
        # p "s #{placement[0..9]}"
        # p "f #{p[0..9]}"
        # placement[0..9] == p[0..9]
    #     placement1[0..(@p_len -1)] == placement2[0..(@p_len -1)]
    #   end
    # end
    # p count
    # found = true if count == 3
    # p_placements next_placements_from_s if count == 1
    # p_placements @ptn if count == 1
    # p "#{@ptn.length}"
  end

  return count
end

def move placement, before, after
  p_dup = placement.dup
  tmp = p_dup[after]
  p_dup[after], p_dup[before] = p_dup[before], tmp
  p_dup[@p_len] = before.to_s

  p_dup
end

def move_all placement
  placements = []
  now = placement.index("0")
  before = placement[@p_len].to_i
  # p "#{now}, #{@half}, #{before}"
  # p "#{now - @half - 1}"
  if now < @half
    if before != now + @half
      tmp = move placement, now, now + @half
      placements << tmp if @ptn.add? tmp
    end
    if before != now + @half + 1 && now < @half - 1
      tmp = move placement, now, now + @half + 1
      placements << tmp if @ptn.add? tmp
    end
    if before != now + @half - 1 && now > 0
      tmp = move placement, now, now + @half - 1
      placements << tmp if @ptn.add? tmp
    end
  else
    if before != now - @half
      tmp = move placement, now, now - @half
      placements << tmp if @ptn.add? tmp
    end
    if before != now - @half - 1 && now > @half
      tmp = move placement, now, now - @half - 1
      placements << tmp if @ptn.add? tmp
    end
    if before != now - @half + 1 && now < @p_len -1
      tmp = move placement, now, now - @half + 1
      placements << tmp if @ptn.add? tmp
    end
  end

  placements
end

answer = solve [@start], [@fin]
puts answer * 2 + 1
