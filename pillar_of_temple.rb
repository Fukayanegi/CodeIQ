@start = "12345678900"
@fin = "02345678911"

def p_pillar placement
  p "*"*30
  p placement[0..4]
  p placement[5..9]
end

def p_placements placements
  placements.each do |placement|
    p_pillar placement
  end
end

def p_placements2 placements
  placements.each do |placement|
    p placement
  end
end

def solve start, fin
  before_placements_from_s = []
  before_placements_from_f = []
  found = false
  count = 0

  # p 'before'
  # p_placements fin
  before_placements_from_s = start
  before_placements_from_f = fin

  while !found do
  # count.times do |i|
    next_placements_from_s = []
    next_placements_from_f = []

    before_placements_from_s.each do |placement|
      next_placements_from_s.concat (move_all placement)
    end

    before_placements_from_f.each do |placement|
      next_placements_from_f.concat (move_all placement)
    end

    count += 1
    before_placements_from_s = next_placements_from_s
    before_placements_from_f = next_placements_from_f

    # p "#{count+1}times after"
    # p_placements next_placements_from_f

    next_placements_from_s.each do |placement|
      found = next_placements_from_f.any? do |p|
        p "s #{placement[0..9]}"
        p "f #{p[0..9]}"
        placement[0..9] == p[0..9]
      end
    end
    p count
    found = true if count == 3
    # p_placements2 next_placements_from_s if count == 10
  end

  return found ? count : -1*before_placements_from_s.length
end

def move placement, before, after
  p_dup = placement.dup
  tmp = p_dup[after]
  p_dup[after], p_dup[before] = p_dup[before], tmp
  p_dup[10] = before.to_s

  p_dup
end

def move_all placement
  placements = []
  now = placement.index("0")
  before = placement[10].to_i
  if now < 5
    if before != now + 5
      placements << (move placement, now, now + 5)
    end
    if before != now + 6 && now < 4
      placements << (move placement, now, now + 6)
    end
    if before != now + 4 && now > 0
      placements << (move placement, now, now + 4)
    end
  else
    if before != now - 5
      placements << (move placement, now, now - 5)
    end
    if before != now - 6 && now > 5
      placements << (move placement, now, now - 6)
    end
    if before != now - 4 && now < 9
      placements << (move placement, now, now - 4)
    end
  end

  placements
end

# in = STDIN.gets
# if in.nil?
#   puts "Warning input not be nil"
#   exit 0
# end

answer = solve [@start], [@fin]
puts answer
