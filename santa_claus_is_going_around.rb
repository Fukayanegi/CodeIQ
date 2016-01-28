c_houses_all = STDIN.gets.chomp.to_i
houses = []
@memo = Hash.new

c_houses_all.times do
  houses << STDIN.gets.chomp.to_i
end

def calc_best_route houses
  c_houses = houses.length
  return [] if c_houses == 0
  return houses if c_houses == 1

  min_energy = Float::INFINITY
  best_route = []

  c_houses.times do |target_i|
    target = houses.slice!(target_i-1)

    (c_houses-1).times do |visit_i|
      # p "#{target}, #{houses[0..visit_i]}, #{houses[visit_i+1..(c_houses-2)]}"

      key = create_key houses[0..visit_i], target, houses[visit_i+1..(c_houses-2)]

      if @memo.include? key
        route = @memo[key]
      else
        passed = calc_best_route houses[0..visit_i]
        rest = calc_best_route houses[visit_i+1..(c_houses-2)]
        route = ([].concat(passed) << target).concat(rest)      
        @memo[key] = route
      end

      energy = calc_energy route
      min_energy, best_route = min_energy > energy ? [energy, route] : [min_energy, best_route]
    end

    # p min_energy
    houses.insert target_i-1, target
  end

  best_route
end

def create_key passed, nxt, rest
  "#{passed.sort.join("")}:#{nxt}:#{rest.sort.join("")}"
end

def calc_energy route
    energy = 0
    route.length.times do |route_i|
      from = route_i > 0 ? route[route_i-1] : 0
      to = route[route_i]
      energy += from * to * route[route_i..route.length].inject(:+)
    end

    energy
end

route = calc_best_route houses

# p route
p calc_energy route